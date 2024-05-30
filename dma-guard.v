`timescale  1ps/1ps

module dma_guard (
    input wire reset_n,

    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ctrl_clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF CTRL_S_AXI, FREQ_HZ 100000000" *)
    input wire ctrl_clk,

    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 data_clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF DATA_M_AXI:DATA_S_AXI, FREQ_HZ 125000000" *)
    input wire data_clk,

     /*
     * DMAGuard control interface
     */

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI AWADDR" *)
    (* X_INTERFACE_PARAMETER = "CLK_DOMAIN ctrl_clk, ID_WIDTH 0, PROTOCOL AXI4, DATA_WIDTH 32" *)
    input  wire [31:0]              ctrl_s_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI AWLEN" *)
    input  wire [7:0]               ctrl_s_axi_awlen,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI AWSIZE" *)
    input  wire [2:0]               ctrl_s_axi_awsize,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI AWBURST" *)
    input  wire [1:0]               ctrl_s_axi_awburst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI AWLOCK" *)
    input  wire                     ctrl_s_axi_awlock,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI AWCACHE" *)
    input  wire [3:0]               ctrl_s_axi_awcache,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI AWPROT" *)
    input  wire [2:0]               ctrl_s_axi_awprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI AWVALID" *)
    input  wire                     ctrl_s_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI AWREADY" *)
    output wire                     ctrl_s_axi_awready,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI WDATA" *)
    input  wire [31:0]              ctrl_s_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI WSTRB" *)
    input  wire [15:0]              ctrl_s_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI WLAST" *)
    input  wire                     ctrl_s_axi_wlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI WVALID" *)
    input  wire                     ctrl_s_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI WREADY" *)
    output wire                     ctrl_s_axi_wready,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI BRESP" *)
    output wire [1:0]               ctrl_s_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI BVALID" *)
    output wire                     ctrl_s_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI BREADY" *)
    input  wire                     ctrl_s_axi_bready,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI ARADDR" *)
    input  wire [31:0]              ctrl_s_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI ARLEN" *)
    input  wire [7:0]               ctrl_s_axi_arlen,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI ARSIZE" *)
    input  wire [2:0]               ctrl_s_axi_arsize,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI ARBURST" *)
    input  wire [1:0]               ctrl_s_axi_arburst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI ARLOCK" *)
    input  wire                     ctrl_s_axi_arlock,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI ARCACHE" *)
    input  wire [3:0]               ctrl_s_axi_arcache,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI ARPROT" *)
    input  wire [2:0]               ctrl_s_axi_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI ARVALID" *)
    input  wire                     ctrl_s_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI ARREADY" *)
    output wire                     ctrl_s_axi_arready,
   
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI RDATA" *)
    output wire [31:0]              ctrl_s_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI RRESP" *)
    output wire [1:0]               ctrl_s_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI RLAST" *)
    output wire                     ctrl_s_axi_rlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI RVALID" *)
    output wire                     ctrl_s_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 CTRL_S_AXI RREADY" *)
    input  wire                     ctrl_s_axi_rready,

    /*
    * This is the data interface
    */

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI AWADDR" *)
    // (* X_INTERFACE_PARAMETER = "CLK_DOMAIN data_clk, ID_WIDTH 3, PROTOCOL AXI4, DATA_WIDTH 256, FREQ_HZ 125000000" *)
    (* X_INTERFACE_PARAMETER = "CLK_DOMAIN data_clk, ID_WIDTH 3, PROTOCOL AXI4, DATA_WIDTH 64, FREQ_HZ 125000000" *)
    input  wire [63:0]              data_s_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI AWLEN" *)
    input  wire [7:0]               data_s_axi_awlen,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI AWSIZE" *)
    input  wire [2:0]               data_s_axi_awsize,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI AWBURST" *)
    input  wire [1:0]               data_s_axi_awburst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI AWLOCK" *)
    input  wire                     data_s_axi_awlock,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI AWCACHE" *)
    input  wire [3:0]               data_s_axi_awcache,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI AWPROT" *)
    input  wire [2:0]               data_s_axi_awprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI AWVALID" *)
    input  wire                     data_s_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI AWREADY" *)
    output wire                     data_s_axi_awready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI AWID" *)
    input  wire [2:0]               data_s_axi_awid,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI WDATA" *)
    input  wire [255:0]             data_s_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI WSTRB" *)
    input  wire [31:0]              data_s_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI WLAST" *)
    input  wire                     data_s_axi_wlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI WVALID" *)
    input  wire                     data_s_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI WREADY" *)
    output wire                     data_s_axi_wready,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI BRESP" *)
    output wire [1:0]               data_s_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI BVALID" *)
    output wire                     data_s_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI BREADY" *)
    input  wire                     data_s_axi_bready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI BID" *)
    output wire [2:0]               data_s_axi_bid,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI ARADDR" *)
    input  wire [63:0]              data_s_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI ARLEN" *)
    input  wire [7:0]               data_s_axi_arlen,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI ARSIZE" *)
    input  wire [2:0]               data_s_axi_arsize,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI ARBURST" *)
    input  wire [1:0]               data_s_axi_arburst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI ARLOCK" *)
    input  wire                     data_s_axi_arlock,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI ARCACHE" *)
    input  wire [3:0]               data_s_axi_arcache,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI ARPROT" *)
    input  wire [2:0]               data_s_axi_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI ARVALID" *)
    input  wire                     data_s_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI ARREADY" *)
    output wire                     data_s_axi_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI ARID" *)
    input  wire [2:0]               data_s_axi_arid,
   
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI RDATA" *)
    output wire [255:0]             data_s_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI RRESP" *)
    output wire [1:0]               data_s_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI RLAST" *)
    output wire                     data_s_axi_rlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI RVALID" *)
    output wire                     data_s_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI RREADY" *)
    input  wire                     data_s_axi_rready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_S_AXI RID" *)
    output wire [2:0]               data_s_axi_rid,

    /*
     * AXI master interface
     */

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI AWADDR" *)
    // (* X_INTERFACE_PARAMETER = "CLK_DOMAIN data_clk, ID_WIDTH 3, PROTOCOL AXI4, DATA_WIDTH 256, FREQ_HZ 125000000" *)
    (* X_INTERFACE_PARAMETER = "CLK_DOMAIN data_clk, ID_WIDTH 3, PROTOCOL AXI4, DATA_WIDTH 64, FREQ_HZ 125000000" *)
    output wire [33:0]              data_m_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI AWLEN" *)
    output wire [7:0]               data_m_axi_awlen,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI AWSIZE" *)
    output wire [2:0]               data_m_axi_awsize,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI AWBURST" *)
    output wire [1:0]               data_m_axi_awburst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI AWLOCK" *)
    output wire                     data_m_axi_awlock,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI AWCACHE" *)
    output wire [3:0]               data_m_axi_awcache,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI AWPROT" *)
    output wire [2:0]               data_m_axi_awprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI AWVALID" *)
    output wire                     data_m_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI AWREADY" *)
    input  wire                     data_m_axi_awready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI AWID" *)
    output wire [2:0]               data_m_axi_awid,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI WDATA" *)
    output wire [255:0]             data_m_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI WSTRB" *)
    output wire [31:0]              data_m_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI WLAST" *)
    output wire                     data_m_axi_wlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI WVALID" *)
    output wire                     data_m_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI WREADY" *)
    input  wire                     data_m_axi_wready,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI BRESP" *)
    input  wire [1:0]               data_m_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI BVALID" *)
    input  wire                     data_m_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI BREADY" *)
    output wire                     data_m_axi_bready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI BID" *)
    input  wire [2:0]               data_m_axi_bid,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI ARADDR" *)
    output wire [33:0]              data_m_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI ARLEN" *)
    output wire [7:0]               data_m_axi_arlen,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI ARSIZE" *)
    output wire [2:0]               data_m_axi_arsize,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI ARBURST" *)
    output wire [1:0]               data_m_axi_arburst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI ARLOCK" *)
    output wire                     data_m_axi_arlock,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI ARCACHE" *)
    output wire [3:0]               data_m_axi_arcache,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI ARPROT" *)
    output wire [2:0]               data_m_axi_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI ARVALID" *)
    output wire                     data_m_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI ARREADY" *)
    input  wire                     data_m_axi_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI ARID" *)
    output wire [2:0]               data_m_axi_arid,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI RDATA" *)
    input  wire [255:0]             data_m_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI RRESP" *)
    input  wire [1:0]               data_m_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI RLAST" *)
    input  wire                     data_m_axi_rlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI RVALID" *)
    input  wire                     data_m_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI RREADY" *)
    output wire                     data_m_axi_rready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 DATA_M_AXI RID" *)
    input  wire [2:0]               data_m_axi_rid,

    output wire interrupt,
    
    output wire [127:0] dbg_key,
    output wire [127:0] dbg_metadata,
    output wire         dbg_done,
    output wire [15:0]  dbg_hash,
    output wire [63:0]  dbg_pointer,
    output wire         dbg_authenticate_ok,
    output wire         dbg_lower_bound_ok,
    output wire         dbg_upper_bound_ok
);

    // assign data_m_axi_awaddr =  data_s_axi_awaddr[33:0];
    // assign data_m_axi_awlen =   data_s_axi_awlen; 
    // assign data_m_axi_awsize =  data_s_axi_awsize;
    // assign data_m_axi_awburst = data_s_axi_awburst;
    // assign data_m_axi_awlock =  data_s_axi_awlock;
    // assign data_m_axi_awcache = data_s_axi_awcache;
    // assign data_m_axi_awprot =  data_s_axi_awprot;
    // assign data_m_axi_awvalid = data_s_axi_awvalid;
    // assign data_s_axi_awready = data_m_axi_awready;
    // assign data_m_axi_awid =    data_s_axi_awid;
    
    // assign data_m_axi_wdata =   data_s_axi_wdata;
    // assign data_m_axi_wstrb =   data_s_axi_wstrb;
    // assign data_m_axi_wlast =   data_s_axi_wlast;
    // assign data_m_axi_wvalid =  data_s_axi_wvalid;
    // assign data_s_axi_wready =  data_m_axi_wready;
    
    // assign data_s_axi_bresp =   data_m_axi_bresp;
    // assign data_s_axi_bvalid =  data_m_axi_bvalid;
    // assign data_m_axi_bready =  data_s_axi_bready;
    // assign data_s_axi_bid =     data_m_axi_bid;
    
    // assign data_m_axi_araddr =  data_s_axi_araddr[33:0];
    // assign data_m_axi_arlen =   data_s_axi_arlen;
    // assign data_m_axi_arsize =  data_s_axi_arsize;
    // assign data_m_axi_arburst = data_s_axi_arburst;
    // assign data_m_axi_arlock =  data_s_axi_arlock;
    // assign data_m_axi_arcache = data_s_axi_arcache;
    // assign data_m_axi_arprot =  data_s_axi_arprot;
    // assign data_m_axi_arvalid = data_s_axi_arvalid;
    // assign data_s_axi_arready = data_m_axi_arready;
    // assign data_m_axi_arid =    data_s_axi_arid;
    
    // assign data_s_axi_rdata =   data_m_axi_rdata;
    // assign data_s_axi_rresp =   data_m_axi_rresp;
    // assign data_s_axi_rlast =   data_m_axi_rlast;
    // assign data_s_axi_rvalid =  data_m_axi_rvalid;
    // assign data_m_axi_rready =  data_s_axi_rready;
    // assign data_s_axi_rid =     data_m_axi_rid;

    // assign interrupt = 1'b0;

    wire        ena;
    wire [3:0]  wea;
    wire [17:0] addra;
    wire [31:0] dina;
    wire [31:0] douta;

    wire        enb;
    // assign enb = 1;
    wire [15:0] web;
    // assign web = 0;
    wire [15:0] addrb;
    // assign addrb = 0;
    wire [127:0]dinb;
    // assign dinb = 0;
    wire [127:0]doutb;
    // assign doutb = 0;


    wire [127:0] key;

    // This is just a *True Dual Port BRAM*.
    // Port a: control port
    // Port b: guard port
    metadata_memory metadata_table (
        .clka(ctrl_clk),
        .ena(ena),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .douta(douta),

        .clkb(data_clk),
        .enb(enb),
        .web(web),
        .addrb(addrb),
        .dinb(dinb),
        .doutb(doutb)
    );

    dma_guard_ctrl_interface ctrl_interface (
        .ctrl_clk(ctrl_clk),
        .reset(~reset_n),

        .ctrl_s_axi_awaddr(ctrl_s_axi_awaddr),
        .ctrl_s_axi_awlen(ctrl_s_axi_awlen),
        .ctrl_s_axi_awsize(ctrl_s_axi_awsize),
        .ctrl_s_axi_awburst(ctrl_s_axi_awburst),
        .ctrl_s_axi_awlock(ctrl_s_axi_awlock),
        .ctrl_s_axi_awcache(ctrl_s_axi_awcache),
        .ctrl_s_axi_awprot(ctrl_s_axi_awprot),
        .ctrl_s_axi_awvalid(ctrl_s_axi_awvalid),
        .ctrl_s_axi_awready(ctrl_s_axi_awready),
    
        .ctrl_s_axi_wdata(ctrl_s_axi_wdata),
        .ctrl_s_axi_wstrb(ctrl_s_axi_wstrb),
        .ctrl_s_axi_wlast(ctrl_s_axi_wlast),
        .ctrl_s_axi_wvalid(ctrl_s_axi_wvalid),
        .ctrl_s_axi_wready(ctrl_s_axi_wready),
    
        .ctrl_s_axi_bresp(ctrl_s_axi_bresp),
        .ctrl_s_axi_bvalid(ctrl_s_axi_bvalid),
        .ctrl_s_axi_bready(ctrl_s_axi_bready),
    
        .ctrl_s_axi_araddr(ctrl_s_axi_araddr),
        .ctrl_s_axi_arlen(ctrl_s_axi_arlen),
        .ctrl_s_axi_arsize(ctrl_s_axi_arsize),
        .ctrl_s_axi_arburst(ctrl_s_axi_arburst),
        .ctrl_s_axi_arlock(ctrl_s_axi_arlock),
        .ctrl_s_axi_arcache(ctrl_s_axi_arcache),
        .ctrl_s_axi_arprot(ctrl_s_axi_arprot),
        .ctrl_s_axi_arvalid(ctrl_s_axi_arvalid),
        .ctrl_s_axi_arready(ctrl_s_axi_arready),
   
        .ctrl_s_axi_rdata(ctrl_s_axi_rdata),
        .ctrl_s_axi_rresp(ctrl_s_axi_rresp),
        .ctrl_s_axi_rlast(ctrl_s_axi_rlast),
        .ctrl_s_axi_rvalid(ctrl_s_axi_rvalid),
        .ctrl_s_axi_rready(ctrl_s_axi_rready),

        .ena(ena),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .douta(douta),
        .key(key) 
    );


    dma_guard_data_interface data_interface (
        .data_clk(data_clk),
        .data_s_axi_awaddr(data_s_axi_awaddr),
        .data_s_axi_awlen(data_s_axi_awlen),
        .data_s_axi_awsize(data_s_axi_awsize),
        .data_s_axi_awburst(data_s_axi_awburst),
        .data_s_axi_awlock(data_s_axi_awlock),
        .data_s_axi_awcache(data_s_axi_awcache),
        .data_s_axi_awprot(data_s_axi_awprot),
        .data_s_axi_awvalid(data_s_axi_awvalid),
        .data_s_axi_awready(data_s_axi_awready),
        .data_s_axi_awid(data_s_axi_awid),
    
        .data_s_axi_wdata(data_s_axi_wdata),
        .data_s_axi_wstrb(data_s_axi_wstrb),
        .data_s_axi_wlast(data_s_axi_wlast),
        .data_s_axi_wvalid(data_s_axi_wvalid),
        .data_s_axi_wready(data_s_axi_wready),
    
        .data_s_axi_bresp(data_s_axi_bresp),
        .data_s_axi_bvalid(data_s_axi_bvalid),
        .data_s_axi_bready(data_s_axi_bready),
        .data_s_axi_bid(data_s_axi_bid),
    
        .data_s_axi_araddr(data_s_axi_araddr),
        .data_s_axi_arlen(data_s_axi_arlen),
        .data_s_axi_arsize(data_s_axi_arsize),
        .data_s_axi_arburst(data_s_axi_arburst),
        .data_s_axi_arlock(data_s_axi_arlock),
        .data_s_axi_arcache(data_s_axi_arcache),
        .data_s_axi_arprot(data_s_axi_arprot),
        .data_s_axi_arvalid(data_s_axi_arvalid),
        .data_s_axi_arready(data_s_axi_arready),
        .data_s_axi_arid(data_s_axi_arid),
   
        .data_s_axi_rdata(data_s_axi_rdata),
        .data_s_axi_rresp(data_s_axi_rresp),
        .data_s_axi_rlast(data_s_axi_rlast),
        .data_s_axi_rvalid(data_s_axi_rvalid),
        .data_s_axi_rready(data_s_axi_rready),
        .data_s_axi_rid(data_s_axi_rid),

        .data_m_axi_awaddr(data_m_axi_awaddr),
        .data_m_axi_awlen(data_m_axi_awlen),
        .data_m_axi_awsize(data_m_axi_awsize),
        .data_m_axi_awburst(data_m_axi_awburst),
        .data_m_axi_awlock(data_m_axi_awlock),
        .data_m_axi_awcache(),
        .data_m_axi_awprot(data_m_axi_awprot),
        .data_m_axi_awvalid(data_m_axi_awvalid),
        .data_m_axi_awready(data_m_axi_awready),
        .data_m_axi_awid(data_m_axi_awid),
    
        .data_m_axi_wdata(data_m_axi_wdata),
        .data_m_axi_wstrb(data_m_axi_wstrb),
        .data_m_axi_wlast(data_m_axi_wlast),
        .data_m_axi_wvalid(data_m_axi_wvalid),
        .data_m_axi_wready(data_m_axi_wready),
    
        .data_m_axi_bresp(data_m_axi_bresp),
        .data_m_axi_bvalid(data_m_axi_bvalid),
        .data_m_axi_bready(data_m_axi_bready),
        .data_m_axi_bid(data_m_axi_bid),
    
        .data_m_axi_araddr(data_m_axi_araddr),
        .data_m_axi_arlen(data_m_axi_arlen),
        .data_m_axi_arsize(data_m_axi_arsize),
        .data_m_axi_arburst(data_m_axi_arburst),
        .data_m_axi_arlock(data_m_axi_arlock),
        .data_m_axi_arcache(data_m_axi_arcache),
        .data_m_axi_arprot(data_m_axi_arprot),
        .data_m_axi_arvalid(data_m_axi_arvalid),
        .data_m_axi_arready(data_m_axi_arready),
        .data_m_axi_arid(data_m_axi_arid),
    
        .data_m_axi_rdata(data_m_axi_rdata),
        .data_m_axi_rresp(data_m_axi_rresp),
        .data_m_axi_rlast(data_m_axi_rlast),
        .data_m_axi_rvalid(data_m_axi_rvalid),
        .data_m_axi_rready(data_m_axi_rready),
        .data_m_axi_rid(data_m_axi_rid),

        .enb(enb),
        .web(web),
        .addrb(addrb),
        .dinb(dinb),
        .doutb(doutb),

        .key(key),
        .dbg_metadata(dbg_metadata),
        .dbg_done(dbg_done),
        .dbg_hash(dbg_hash),
        .dbg_pointer(dbg_pointer),
        .dbg_authenticate_ok(dbg_authenticate_ok),
        .dbg_lower_bound_ok(dbg_lower_bound_ok),
        .dbg_upper_bound_ok(dbg_upper_bound_ok),

        .interrupt(interrupt)
    );

    // assign dbg_metadata = doutb;
    assign dbg_key = key;

endmodule
