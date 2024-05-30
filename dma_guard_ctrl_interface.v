`timescale  1ps / 1ps

module dma_guard_ctrl_interface (
    input  wire ctrl_clk,
    input  wire reset,
    input  wire [31:0]              ctrl_s_axi_awaddr,
    input  wire [7:0]               ctrl_s_axi_awlen,
    input  wire [2:0]               ctrl_s_axi_awsize,
    input  wire [1:0]               ctrl_s_axi_awburst,
    input  wire                     ctrl_s_axi_awlock,
    input  wire [3:0]               ctrl_s_axi_awcache,
    input  wire [2:0]               ctrl_s_axi_awprot,
    input  wire                     ctrl_s_axi_awvalid,
    output reg                      ctrl_s_axi_awready,
    
    input  wire [31:0]              ctrl_s_axi_wdata,
    input  wire [15:0]              ctrl_s_axi_wstrb,
    input  wire                     ctrl_s_axi_wlast,
    input  wire                     ctrl_s_axi_wvalid,
    output reg                      ctrl_s_axi_wready,
    
    output reg  [1:0]               ctrl_s_axi_bresp, // not used, always 0
    output reg                      ctrl_s_axi_bvalid,
    input  wire                     ctrl_s_axi_bready,
    
    input  wire [31:0]              ctrl_s_axi_araddr,
    input  wire [7:0]               ctrl_s_axi_arlen,
    input  wire [2:0]               ctrl_s_axi_arsize,
    input  wire [1:0]               ctrl_s_axi_arburst,
    input  wire                     ctrl_s_axi_arlock,
    input  wire [3:0]               ctrl_s_axi_arcache,
    input  wire [2:0]               ctrl_s_axi_arprot,
    input  wire                     ctrl_s_axi_arvalid,
    output reg                      ctrl_s_axi_arready,
   
    output reg  [31:0]              ctrl_s_axi_rdata,
    output reg  [1:0]               ctrl_s_axi_rresp, // not used, always 0
    output reg                      ctrl_s_axi_rlast,
    output reg                      ctrl_s_axi_rvalid,
    input  wire                     ctrl_s_axi_rready,

    output reg                      ena,
    output reg  [3:0]               wea,
    output reg  [17:0]              addra,
    output reg  [31:0]              dina,
    input  wire [31:0]              douta,
    output wire [127:0]             key
);

    localparam STATE_IDLE =             4'h0;
    localparam STATE_WRITE_METADATA =   4'h1;
    localparam STATE_WRITE_KEY =        4'h2;
    localparam STATE_WRITE_LAST =       4'h3;
    localparam STATE_READ_METADATA  =   4'h4;
    localparam STATE_READ_KEY =         4'h5;
    localparam STATE_READ_KEY_LAST =    4'h6;
    localparam STATE_RESET =            4'h7;
    localparam STATE_READ_METADATA_LAST=4'h8;

    reg [4:0] state;
    reg [31:0] key_storage [0:3];
    reg key_wen;
    reg [1:0] key_addr;
    reg [31:0] key_din;

    assign key = { key_storage[3], key_storage[2], key_storage[1], key_storage[0] };

    reg [8:0] read_counter;

    initial begin
        state <= STATE_IDLE;

        ctrl_s_axi_awready <= 0;
        ctrl_s_axi_wready <= 0;
        ctrl_s_axi_bresp <= 0;
        ctrl_s_axi_bvalid <= 0;
        ctrl_s_axi_arready <= 0;
        ctrl_s_axi_rdata <= 0;
        ctrl_s_axi_rresp <= 0;
        ctrl_s_axi_rlast <= 0;
        ctrl_s_axi_rvalid <= 0;

        ena <= 1;
        wea <= 0;
        addra <= 0;
        dina <= 0;

        read_counter <= 0;

        key_wen <= 0;
        key_addr <= 0;
        key_din <= 0;
        key_storage[3] <= 32'h0f0f0f0f;
        key_storage[2] <= 32'h0e0e0e0e;
        key_storage[1] <= 32'h0d0d0d0d;
        key_storage[0] <= 32'h0c0c0c0c;
    end

    always @ (posedge ctrl_clk) begin
        if (reset) begin
            key_storage[3] <= 32'h0f0f0f0f;
            key_storage[2] <= 32'h0e0e0e0e;
            key_storage[1] <= 32'h0d0d0d0d;
            key_storage[0] <= 32'h0c0c0c0c;
        end else begin
            if (key_wen) begin
                key_storage[key_addr] <= key_din;
            end        
        end
    end

    // Pipeline
    reg [1:0] previous_read_valid;
    reg [1:0] previous_read_last;
    initial begin
        previous_read_valid <= 0;
        previous_read_last <= 0;
    end

    always @ (posedge ctrl_clk) begin
        if (reset) begin
            state <= STATE_IDLE;

            ctrl_s_axi_awready <= 0;
            ctrl_s_axi_wready <= 0;
            ctrl_s_axi_bresp <= 0;
            ctrl_s_axi_bvalid <= 0;
            ctrl_s_axi_arready <= 0;
            ctrl_s_axi_rdata <= 0;
            ctrl_s_axi_rresp <= 0;
            ctrl_s_axi_rlast <= 0;
            ctrl_s_axi_rvalid <= 0;

            ena <= 1;
            wea <= 0;
            addra <= 0;
            dina <= 0;

            key_wen <= 0;
            key_addr <= 0;
            key_din <= 0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (ctrl_s_axi_awvalid) begin
                        ctrl_s_axi_awready <= 1;
                        // if (ctrl_s_axi_awaddr >= 21'h100000) begin
                        if ((ctrl_s_axi_awaddr & 32'h100000) == 32'h100000) begin
                            state <= STATE_WRITE_METADATA;
                            addra <= ctrl_s_axi_awaddr[19:2] - 1;   // we should start at -1
                        end else begin
                            state <= STATE_WRITE_KEY;
                            key_addr <= ctrl_s_axi_awaddr[3:2] - 1; // we should start at -1
                        end
                    end else if (ctrl_s_axi_arvalid) begin
                        ctrl_s_axi_arready <= 1;
                        read_counter <= ctrl_s_axi_arlen + 1;
                        // if (ctrl_s_axi_araddr >= 21'h100000) begin
                        if ((ctrl_s_axi_araddr & 32'h100000) == 32'h100000) begin
                            state <= STATE_READ_METADATA;
                            addra <= ctrl_s_axi_araddr[19:2];       // when read, start at 0
                        end else begin
                            state <= STATE_READ_KEY;
                            key_addr <= ctrl_s_axi_araddr[3:2];     // when read, start at 0
                        end
                    end else begin
                        state <= STATE_IDLE;
                    end
                end

                STATE_READ_KEY: begin
                    ctrl_s_axi_arready <= 0;

                    if (ctrl_s_axi_rready) begin
                        key_addr <= key_addr + 1;
                        ctrl_s_axi_rdata <= key_storage[key_addr];
                        ctrl_s_axi_rvalid <= 1;
                        read_counter <= read_counter - 1;
                        if (read_counter == 1) begin
                            ctrl_s_axi_rlast <= 1;
                            state <= STATE_READ_KEY_LAST;
                        end else begin
                            state <= STATE_READ_KEY;
                        end
                    end
                end

                STATE_READ_METADATA: begin
                    ctrl_s_axi_arready <= 0;

                    if (ctrl_s_axi_rready) begin
                        addra <= addra + 1;
                        // ctrl_s_axi_rdata <= douta;
                        // ctrl_s_axi_rvalid <= 1;
                        previous_read_valid <= { 1'b1, previous_read_valid[1] };
                        read_counter <= read_counter - 1;
                        if (read_counter == 1) begin
                            // ctrl_s_axi_rlast <= 1;
                            previous_read_last <= 2'b10;
                            state <= STATE_READ_METADATA_LAST;
                        end else begin
                            state <= STATE_READ_METADATA;
                        end
                    end else begin
                        previous_read_valid <= { 1'b0, previous_read_valid[1] };
                        previous_read_last <= { 1'b0, previous_read_last[1] };
                        state <= STATE_READ_METADATA;
                    end

                    if (previous_read_valid[0]) begin
                        ctrl_s_axi_rvalid <= 1;
                        ctrl_s_axi_rdata <= douta;
                    end
                end

                STATE_READ_KEY_LAST: begin
                    ctrl_s_axi_rlast <= 0;
                    ctrl_s_axi_rvalid <= 0;
                    state <= STATE_RESET; 
                end

                STATE_READ_METADATA_LAST: begin
                    // ctrl_s_axi_rlast <= 0;
                    // ctrl_s_axi_rvalid <= 0;
                    if ((previous_read_valid & 2'b10) == 2'b10) begin
                        state <= STATE_READ_METADATA_LAST;
                    end else begin
                        state <= STATE_RESET; 
                    end

                    if (previous_read_valid[0]) begin
                        ctrl_s_axi_rvalid <= 1;
                        ctrl_s_axi_rdata <= douta;
                    end

                    if (previous_read_last[0]) begin
                        ctrl_s_axi_rlast <= 1;
                    end

                    previous_read_valid <= { 1'b0, previous_read_valid[1] };
                    previous_read_last <= { 1'b0, previous_read_last[1] };
                end

                STATE_WRITE_KEY: begin
                    ctrl_s_axi_awready <= 0;
                    ctrl_s_axi_wready <= 1;

                    if (ctrl_s_axi_wvalid) begin
                        key_addr <= key_addr + 1;
                        key_wen <= 1;
                        key_din <= ctrl_s_axi_wdata;
                        if (ctrl_s_axi_wlast) begin
                            // last data 
                            state <= STATE_WRITE_LAST;
                        end else begin
                            // more data to go
                            state <= STATE_WRITE_KEY;
                        end
                    end else begin
                        key_wen <= 0;
                        state <= STATE_WRITE_KEY;
                    end
                end

                STATE_WRITE_METADATA: begin
                    ctrl_s_axi_awready <= 0;
                    ctrl_s_axi_wready <= 1;

                    if (ctrl_s_axi_wvalid) begin
                        addra <= addra + 1;
                        wea <= 4'hf;
                        dina <= ctrl_s_axi_wdata;
                        if (ctrl_s_axi_wlast) begin
                            state <= STATE_WRITE_LAST; 
                        end else begin
                            state <= STATE_WRITE_METADATA;
                        end
                    end else begin
                        wea <= 0;
                        state <= STATE_WRITE_METADATA;
                    end
                end

                STATE_WRITE_LAST: begin
                    key_wen <= 0;
                    wea <= 0;
                    if (ctrl_s_axi_bready) begin
                        ctrl_s_axi_bvalid <= 1;
                        state <= STATE_RESET;
                    end else begin
                        state <= STATE_WRITE_LAST;
                    end
                end

                STATE_RESET: begin
                    state <= STATE_IDLE;

                    ctrl_s_axi_awready <= 0;
                    ctrl_s_axi_wready <= 0;
                    ctrl_s_axi_bresp <= 0;
                    ctrl_s_axi_bvalid <= 0;
                    ctrl_s_axi_arready <= 0;
                    ctrl_s_axi_rdata <= 0;
                    ctrl_s_axi_rresp <= 0;
                    ctrl_s_axi_rlast <= 0;
                    ctrl_s_axi_rvalid <= 0;

                    ena <= 1;
                    wea <= 0;
                    addra <= 0;
                    dina <= 0;

                    key_wen <= 0;
                    key_addr <= 0;
                    key_din <= 0;

                    read_counter <= 0;

                    previous_read_last <= 0;
                    previous_read_valid <= 0;
                end
            endcase
        end
    end

endmodule