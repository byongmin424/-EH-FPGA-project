module DDI_Testbench;

// Parameters
parameter BAUD_RATE = 9600;
parameter HEADER = 8'hAA; // Set your desired header value
parameter IMAGE_DATA = 8'h55; // Set your desired image data value
parameter CHECKSUM = 8'hFF; // Set your desired checksum value

// Signals
reg clk, rst;
reg [7:0] tx_data;
wire tx;
wire [15:0] strb;
wire [7:0] received_data;
wire header_valid, data_valid, checksum_valid;

// Instantiate DUT
uart_rx uut (
    .clk(clk),
    .rst(rst),
    .tx(tx),
    .strb(strb),
    .received_data(received_data),
    .header_valid(header_valid),
    .data_valid(data_valid),
    .checksum_valid(checksum_valid)
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
    // Header transmission
    tx_data = HEADER;
    #100;

    // Image data transmission
    tx_data = IMAGE_DATA;
    #100;

    // Checksum transmission
    tx_data = CHECKSUM;
    #100;

    // Add more test scenarios as needed

    // End simulation
    #1000 $finish;
end

initial 
    begin
      // Required to dump signals to EPWave
      $dumpfile("uart_testbench.vcd");
      $dumpvars(0, DDI_Testbench);
    end

endmodule
