`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2023 09:51:24 AM
// Design Name: 
// Module Name: dma_guard_data_interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dma_guard_data_interface(
    input wire data_clk, 
    input  wire [63:0]              data_s_axi_awaddr,
    input  wire [7:0]               data_s_axi_awlen,
    input  wire [2:0]               data_s_axi_awsize,
    input  wire [1:0]               data_s_axi_awburst,
    input  wire                     data_s_axi_awlock,
    input  wire [3:0]               data_s_axi_awcache,
    input  wire [2:0]               data_s_axi_awprot,
    input  wire                     data_s_axi_awvalid,
    output wire                     data_s_axi_awready,
    input  wire [2:0]               data_s_axi_awid,
    
    input  wire [255:0]             data_s_axi_wdata,
    input  wire [31:0]              data_s_axi_wstrb,
    input  wire                     data_s_axi_wlast,
    input  wire                     data_s_axi_wvalid,
    output wire                     data_s_axi_wready,
    
    output wire [1:0]               data_s_axi_bresp,
    output wire                     data_s_axi_bvalid,
    input  wire                     data_s_axi_bready,
    output wire [2:0]               data_s_axi_bid,
    
    input  wire [63:0]              data_s_axi_araddr,
    input  wire [7:0]               data_s_axi_arlen,
    input  wire [2:0]               data_s_axi_arsize,
    input  wire [1:0]               data_s_axi_arburst,
    input  wire                     data_s_axi_arlock,
    input  wire [3:0]               data_s_axi_arcache,
    input  wire [2:0]               data_s_axi_arprot,
    input  wire                     data_s_axi_arvalid,
    output wire                     data_s_axi_arready,
    input  wire [2:0]               data_s_axi_arid,
   
    output wire [255:0]             data_s_axi_rdata,
    output wire [1:0]               data_s_axi_rresp,
    output wire                     data_s_axi_rlast,
    output wire                     data_s_axi_rvalid,
    input  wire                     data_s_axi_rready,
    output wire [2:0]               data_s_axi_rid,

    output wire [33:0]              data_m_axi_awaddr,
    output wire [7:0]               data_m_axi_awlen,
    output wire [2:0]               data_m_axi_awsize,
    output wire [1:0]               data_m_axi_awburst,
    output wire                     data_m_axi_awlock,
    output wire [3:0]               data_m_axi_awcache,
    output wire [2:0]               data_m_axi_awprot,
    output wire                     data_m_axi_awvalid,
    input  wire                     data_m_axi_awready,
    output wire [2:0]               data_m_axi_awid,
    
    output wire [255:0]             data_m_axi_wdata,
    output wire [31:0]              data_m_axi_wstrb,
    output wire                     data_m_axi_wlast,
    output wire                     data_m_axi_wvalid,
    input  wire                     data_m_axi_wready,
    
    input  wire [1:0]               data_m_axi_bresp,
    input  wire                     data_m_axi_bvalid,
    output wire                     data_m_axi_bready,
    input  wire [2:0]               data_m_axi_bid,
    
    output wire [33:0]              data_m_axi_araddr,
    output wire [7:0]               data_m_axi_arlen,
    output wire [2:0]               data_m_axi_arsize,
    output wire [1:0]               data_m_axi_arburst,
    output wire                     data_m_axi_arlock,
    output wire [3:0]               data_m_axi_arcache,
    output wire [2:0]               data_m_axi_arprot,
    output wire                     data_m_axi_arvalid,
    input  wire                     data_m_axi_arready,
    output wire [2:0]               data_m_axi_arid,
    
    input  wire [255:0]             data_m_axi_rdata,
    input  wire [1:0]               data_m_axi_rresp,
    input  wire                     data_m_axi_rlast,
    input  wire                     data_m_axi_rvalid,
    output wire                     data_m_axi_rready,
    input  wire [2:0]               data_m_axi_rid,


    output reg                      enb,
    output reg  [15:0]              web,
    output reg  [15:0]              addrb,
    output reg  [127:0]             dinb,
    input  wire [127:0]             doutb,

    input wire [127:0]              key,
    output wire [127:0]             dbg_metadata,
    output wire                     dbg_done,
    output wire [15:0]              dbg_hash,
    output wire [63:0]              dbg_pointer,
    output wire                     dbg_authenticate_ok,
    output wire                     dbg_lower_bound_ok,
    output wire                     dbg_upper_bound_ok,

    output reg                      interrupt
);

    assign data_m_axi_awaddr =  data_s_axi_awaddr[33:0];
    assign data_m_axi_awlen =   data_s_axi_awlen; 
    assign data_m_axi_awsize =  data_s_axi_awsize;
    assign data_m_axi_awburst = data_s_axi_awburst;
    assign data_m_axi_awlock =  data_s_axi_awlock;
    assign data_m_axi_awcache = data_s_axi_awcache;
    assign data_m_axi_awprot =  data_s_axi_awprot;
    // assign data_m_axi_awvalid = data_s_axi_awvalid;
    // assign data_s_axi_awready = data_m_axi_awready;
    assign data_m_axi_awid =    data_s_axi_awid;
    
    assign data_m_axi_wdata =   data_s_axi_wdata;
    assign data_m_axi_wstrb =   data_s_axi_wstrb;
    assign data_m_axi_wlast =   data_s_axi_wlast;
    assign data_m_axi_wvalid =  data_s_axi_wvalid;
    assign data_s_axi_wready =  data_m_axi_wready;
    
    assign data_s_axi_bresp =   data_m_axi_bresp;
    assign data_s_axi_bvalid =  data_m_axi_bvalid;
    assign data_m_axi_bready =  data_s_axi_bready;
    assign data_s_axi_bid =     data_m_axi_bid;
    
    assign data_m_axi_araddr =  data_s_axi_araddr[33:0];
    assign data_m_axi_arlen =   data_s_axi_arlen;
    assign data_m_axi_arsize =  data_s_axi_arsize;
    assign data_m_axi_arburst = data_s_axi_arburst;
    assign data_m_axi_arlock =  data_s_axi_arlock;
    assign data_m_axi_arcache = data_s_axi_arcache;
    assign data_m_axi_arprot =  data_s_axi_arprot;
    // assign data_m_axi_arvalid = data_s_axi_arvalid;
    // assign data_s_axi_arready = data_m_axi_arready;
    assign data_m_axi_arid =    data_s_axi_arid;
    
    assign data_s_axi_rdata =   data_m_axi_rdata;
    assign data_s_axi_rresp =   data_m_axi_rresp;
    assign data_s_axi_rlast =   data_m_axi_rlast;
    assign data_s_axi_rvalid =  data_m_axi_rvalid;
    assign data_m_axi_rready =  data_s_axi_rready;
    assign data_s_axi_rid =     data_m_axi_rid;

    reg access_is_valid;
    reg awready;
    reg arready;
    reg arvalid;
    reg awvalid;

    reg start;
    localparam STATE_IDLE =             4'h0;
    localparam STATE_READ_METADATA =    4'h1;
    localparam STATE_WAIT_HASH =        4'h2;
    localparam STATE_WAIT_STABLE =      4'h3;
    localparam STATE_WAIT_METADATA =    4'h4;
    localparam STATE_FINISH_METADATA =  4'h5;
    localparam STATE_WAIT_META_FULL =   4'h6;
    reg [3:0] state;

    initial begin
        enb <= 0;
        web <= 0;
        addrb <= 0;
        dinb <= 0;
        access_is_valid <= 1;
        awready <= 0;
        arready <= 0;
        arvalid <= 0;
        awvalid <= 0;
        interrupt <= 0;
        state <= STATE_IDLE;
    end

    // assign addrb = data_s_axi_arvalid ? data_s_axi_araddr[63:48] : data_s_axi_awaddr[63:48];

    assign data_s_axi_awready = awready;
    assign data_s_axi_arready = arready;
    assign data_m_axi_awvalid = awvalid;
    assign data_m_axi_arvalid = arvalid;

    reg [63:0] pointer_to_check;
    reg [47:0] last_byte_to_access = 0;
    reg [15:0] pac_to_authenticate = 0;
    wire [15:0] hash;
    wire done;
    reg lower_bound_ok = 0;
    reg upper_bound_ok = 0;

    // reg [15:0] index = 0;
    reg hold_ready = 0;

    always @ (posedge data_clk) begin

        // if (data_s_axi_arvalid && arready == 0 && hold_ready == 0) begin   // and it, because otherwise, it is checked twice
        //     hold_ready <= 4'hf;
        // end else if (data_s_axi_awvalid && awready == 0 && hold_ready == 0) begin
        //     hold_ready <= 4'hf;
        // end else if (hold_ready != 0) begin
        //     hold_ready <= hold_ready - 1;
        // end else begin
        //     hold_ready <= 0;
        // end

        if (state == STATE_IDLE) begin
            lower_bound_ok <= 0;
            upper_bound_ok <= 0;
            if (data_s_axi_arvalid && arready == 0 && hold_ready == 0) begin   // and it, because otherwise, it is checked twice
                state <= STATE_WAIT_STABLE; 
                pointer_to_check <= data_s_axi_araddr[47:0];
                pac_to_authenticate <= data_s_axi_araddr[63:48];
                addrb <= data_s_axi_araddr[63:48];
                last_byte_to_access <= data_s_axi_araddr[47:0] + data_s_axi_arlen;

                hold_ready <= 1;
                arready <= 1; 
                arvalid <= 1;
            end else if (data_s_axi_awvalid && awready == 0 && hold_ready == 0) begin
                state <= STATE_WAIT_STABLE; 
                pointer_to_check <= data_s_axi_awaddr[47:0];
                pac_to_authenticate <= data_s_axi_awaddr[63:48];
                addrb <= data_s_axi_awaddr[63:48];
                last_byte_to_access <= data_s_axi_awaddr[47:0] + data_s_axi_awlen;

                hold_ready <= 1;
                awready <= 1;
                awvalid <= 1;
            end else begin
                state <= STATE_IDLE;
            end
        end else if (state == STATE_WAIT_STABLE) begin

            awready <= 0;
            arready <= 0;
            arvalid <= 0;
            awvalid <= 0;
            enb <= 1;
            state <= STATE_WAIT_METADATA;
        end else if (state == STATE_WAIT_METADATA) begin
            state <= STATE_READ_METADATA;
        end else if (state == STATE_READ_METADATA) begin
            // start <= 1;
            state <= STATE_FINISH_METADATA;
        end else if (state == STATE_FINISH_METADATA) begin
            // start <= 1;
            // enb <= 0;
            state <= STATE_WAIT_META_FULL;


        end else if (state == STATE_WAIT_META_FULL) begin
            start <= 1;
            enb <= 0;
            state <= STATE_WAIT_HASH;

            if (metadata[95:48] <= pointer_to_check) begin
                lower_bound_ok <= 1;
            end else begin
                lower_bound_ok <= 0;
            end

            if (metadata[47:0] >= last_byte_to_access) begin
                upper_bound_ok <= 1;
            end else begin
                upper_bound_ok <= 0;
            end

        end else if (state == STATE_WAIT_HASH) begin
            start <= 0;
            if (done) begin
                state <= STATE_IDLE;
                // if (data_s_axi_arvalid & ((pac_to_authenticate == hash) && (upper_bound_ok && lower_bound_ok))) begin
                //     // arready <= 1; 
                //     // arvalid <= 1;
                //     hold_ready <= 0;
                // end else if (data_s_axi_awvalid & ((pac_to_authenticate == hash) && (upper_bound_ok && lower_bound_ok))) begin
                //     // awready <= 1;
                //     // awvalid <= 1;
                //     hold_ready <= 0;
                // end else begin
                //     interrupt <= 1;
                // end
                if (((pac_to_authenticate == hash) && (upper_bound_ok && lower_bound_ok))) begin
                    hold_ready <= 0;
                end else begin
                    interrupt <= 1;
                end
            end else begin
                state <= STATE_WAIT_HASH; 
            end
        end
    end

    wire [127:0] metadata;
    // assign metadata = { doutb[31:0], doutb[63:32], doutb[95:64], doutb[127:96] };
    assign metadata = doutb;
    assign dbg_metadata = metadata;
    assign dbg_done = done;
    assign dbg_pointer = pointer_to_check;
    assign dbg_hash = hash;
    assign dbg_authenticate_ok = (pac_to_authenticate == hash) && (upper_bound_ok && lower_bound_ok);
    assign dbg_upper_bound_ok = upper_bound_ok;
    assign dbg_lower_bound_ok = lower_bound_ok;

    hash_engine hash_calculator (
        .clk(data_clk),
        .metadata(metadata),
        .key(key),
        .pointer(pointer_to_check),
        .start(start),
        .hash(hash),
        .done(done)
    );

endmodule
