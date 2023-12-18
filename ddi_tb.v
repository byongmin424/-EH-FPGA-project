`timescale 1ns/1ps

module ddi_tb;

reg clk;
reg rst;
reg [7:0] tx_data;
reg rx;
wire [7:0] received_data;
wire DataRdy;
wire [7:0] Header;
wire [23:0] ImageData;
wire [7:0] CheckSum;
wire Strb;

// Instantiate text file reader and UART modules
text_file_reader txt_reader();
uart_tx tx_inst(
    .clk(clk),
    .rst(rst),
    .data(tx_data),
    .tx(rx)
);
uart_rx rx_inst(
    .clk(clk),
    .rst(rst),
    .rx(tx),
    .received_data(received_data),
    .DataRdy(DataRdy),
    .Header(Header),
    .ImageData(ImageData),
    .CheckSum(CheckSum),
    .Strb(Strb)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test scenario
initial begin
    // Initialize signals
    rst = 1;
    tx_data = 8'b11011011; // Set your test data

    // Apply reset
    #10 rst = 0;

    // Apply test data and wait for DataRdy signal
    #10 tx_data = 8'b10101010;
    wait(DataRdy);

    // Display received data
    $display("Received Data: %h", received_data);

    // Add more test scenarios as needed

    // Finish simulation
    #10 $finish;
end

endmodule
