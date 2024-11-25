module ST7567_Controller (
    input i_clk,            // System clock
    input i_rst_n,          // Active low reset
    input [7:0] i_data,     // Data to be sent to LCD
    input i_data_mode,      // 1 for data write, 0 for command write
    input i_data_valid,     // Start signal for write operation
    output o_done            // Done signal for operation completion

    output o_lcd_CS,         // Chip select for LCD
    output o_lcd_A0,         // Register select (1 for data, 0 for command)
    output o_lcd_SDA,        // Serial data
    output o_lcd_CLK,        // Serial clock for LCD
    output o_lcd_RES,        // Active low reset
    
);

reg r_lcd_CS;
reg r_lcd_A0;
reg r_lcd_RES;

SPI_Controller st7576_inst (
    .i_clk(sys_clk),
    .i_reset_n(i_rst_n),
    .i_tx_byte(i_data),
    .i_tx_dv(i_data_valid),
    .o_tx_ready(o_done),
    .o_rx_dv(),
    .o_rx_byte(),
    .o_spi_clk(o_lcd_CLK),
    .o_spi_mosi(o_lcd_SDI)
);

// TODO: FSM for initialization and sending images

always @(posedge i_clk or negedge i_reset_n)
begin
    if (!i_reset_n)
    begin
        r_lcd_RES <= 0; // reset
        r_lcd_A0 <= 0;  // reg mode by default
        r_lcd_CS <= 1;  // deselect by default
    end
end

assign o_lcd_CS = r_lcd_CS;
assign o_lcd_A0 = r_lcd_A0;
assign o_lcd_RES = r_lcd_RES;

endmodule
