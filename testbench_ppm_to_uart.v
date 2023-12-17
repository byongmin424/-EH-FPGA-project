// testbench_ppm_to_uart.v

`timescale 1ns/1ps

module testbench_ppm_to_uart;

  reg clk;
  reg rst;
  wire [7:0] tx_data;
  wire tx;

  // Instantiate text_file_reader and uart_tx modules
  text_file_reader text_reader (
    .data(tx_data)
  );

  uart_tx uut_tx (
    .clk(clk),
    .rst(rst),
    .data(tx_data),
    .tx(tx)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generation
  initial begin
    rst = 1;
    #10 rst = 0;
  end

  // Test scenario
  initial begin
    // Add delay for the file to be read before starting UART transmission
    #100;

    // Start UART transmission
    // You may want to add more delays and scenarios based on your specific requirements
    // For example, you can use a state machine to control the transmission process
    #10;

    // End simulation
    #1000 $finish;
  end

initial begin
    $dumpfile("testbench_ppm_to_uart.vcd");
    $dumpvars(1);
end

endmodule
