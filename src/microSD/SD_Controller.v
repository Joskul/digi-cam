module ST7567_Controller (
    input i_clk,            // System clock
    input i_rst_n,          // Active low reset
    input [7:0] i_data,     // Data to be sent to LCD
    input i_data_valid,     // Start signal for write operation
    output o_done,          // Done signal for operation completion

    output o_sd_CS,         // Chip select for LCD
    output o_sd_CLK,        // Serial clock for LCD

    output [7:0]o_res,      // Response from the operation
    output o_res_valid
);

reg r_sd_CS;

SPI_Controller microsd_inst (
    .i_clk(sys_clk),
    .i_reset_n(i_rst_n),
    .i_tx_byte(i_data),
    .i_tx_dv(i_data_valid),
    .o_tx_ready(o_done),
    .o_rx_dv(o_res_valid),
    .o_rx_byte(o_res),
    .o_spi_clk(o_sd_CLK),
    .o_spi_mosi(o_sd_SDI)
);

// TODO: FSM for initialization and storing images

always @(posedge i_clk or negedge i_reset_n)
begin
    if (!i_reset_n)
    begin
        r_sd_CS <= 1;  // deselect by default
    end
end

assign o_sd_CS = r_sd_CS;

endmodule
