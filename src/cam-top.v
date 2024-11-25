module camera_top (
    // System
    input               sys_clk           , // 27MHz
    input               sys_rst_n         ,
    output     [1:0]    O_led           ,
    // User Input
    input               I_zoom_in       ,
    input               I_zoom_out      ,
    input               I_shutter       ,
    // OV2640   
    inout               SDA             ,
    inout               SCL             ,
    input               VSYNC           ,
    input               HREF            ,
    input      [9:0]    PIXDATA         ,
    input               PIXCLK          ,
    output              XCLK            ,
    // SPI (Shared between ST7567 and microSD)
    input               MISO            ,
    output              MOSI            ,
    // ST7567 Display
    output              ST_cs           ,
    output              ST_clk          , // <20MHz
    // microSD
    output              SD_cs           ,
    output              SD_clk          , // 20-25MHz
    // HyperRAM
    output     [0:0]    O_hpram_ck      ,
    output     [0:0]    O_hpram_ck_n    ,
    output     [0:0]    O_hpram_cs_n    ,
    output     [0:0]    O_hpram_reset_n ,
    inout      [7:0]    IO_hpram_dq     ,
    inout      [0:0]    IO_hpram_rwds   
)

reg  [31:0] run_cnt;
wire        running;

//--------------------------
wire        tp0_vs_in  ;
wire        tp0_hs_in  ;
wire        tp0_de_in ;
wire [ 7:0] tp0_data_r/*synthesis syn_keep=1*/;
wire [ 7:0] tp0_data_g/*synthesis syn_keep=1*/;
wire [ 7:0] tp0_data_b/*synthesis syn_keep=1*/;

reg         vs_r;
reg  [9:0]  cnt_vs;

//--------------------------
reg  [9:0]  pixdata_d1;
reg         hcnt;
wire [15:0] cam_data;

//-------------------------
//frame buffer in
wire        ch0_vfb_clk_in ;
wire        ch0_vfb_vs_in  ;
wire        ch0_vfb_de_in  ;
wire [15:0] ch0_vfb_data_in;

//-------------------
//syn_code
wire        syn_off0_re;  // ofifo read enable signal
wire        syn_off0_vs;
wire        syn_off0_hs;
            
wire        off0_syn_de  ;
wire [15:0] off0_syn_data;

//-------------------------------------
//Hyperram
wire        dma_clk  ; 

wire        memory_clk;
wire        mem_pll_lock  ;

//-------------------------------------------------
//memory interface
wire          cmd           ;
wire          cmd_en        ;
wire [21:0]   addr          ;//[ADDR_WIDTH-1:0]
wire [31:0]   wr_data       ;//[DATA_WIDTH-1:0]
wire [3:0]    data_mask     ;
wire          rd_data_valid ;
wire [31:0]   rd_data       ;//[DATA_WIDTH-1:0]
wire          init_calib    ;

//------------------------------------------
//rgb data
wire        rgb_vs     ;
wire        rgb_hs     ;
wire        rgb_de     ;
wire [23:0] rgb_data   ;

// Zoom logic
reg [7:0]zoom_counter;
reg resend_reg;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        zoom_counter <= 8'b0;
    end
    else if (I_zoom_in) begin
        zoom_counter <= zoom_counter + 8'b1;
        resend_reg <= 1'b1;
    end
    else if (I_zoom_out) begin
        zoom_counter <= zoom_counter - 8'b1;
        resend_reg <= 1'b1;
    end else begin
        resend_reg <= 1'b0;
    end
end

OV2640_Controller u_OV2640_Controller
(
    .clk             (clk_12M),         // 24Mhz clock signal
    .resend          (1'b0),            // Reset signal
    .config_finished (), // Flag to indicate that the configuration is finished
    .sioc            (SCL),             // SCCB interface - clock signal
    .siod            (SDA),             // SCCB interface - data signal
    .reset           (),       // RESET signal for OV7670
    .pwdn            (),             // PWDN signal for OV7670
    .zoom            (zoom_counter)
);

// TODO : Initialize all modules and connections

endmodule