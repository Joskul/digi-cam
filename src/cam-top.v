module camera_top (
    // System
    input               I_clk           , // 27MHz
    input               I_rst_n         ,
    output     [1:0]    O_led           ,
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



endmodule