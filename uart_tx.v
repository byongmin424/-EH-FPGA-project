module uart_tx (
    input wire clk,
    input wire rst,
    input wire [7:0] data,
    output reg tx
);

// Parameters for UART configuration
parameter BAUD_RATE = 9600; //Set your desired baud rate

// Internal variables
reg [3:0] count;
reg [11:0] baud_counter;
reg [10:0] bit_counter;
reg start_bit;

// Initialize variables
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        baud_counter <= 0;
        bit_counter <= 0;
        start_bit <= 1;
        tx <= 1;
    end
    
    else begin
        //Baud rate generation
        if (baud_counter == BAUD_RATE / 2 -1) begin
            baud_counter <= 0;
            count <= count + 1;
        end
        else begin
            baud_counter <= baud_counter + 1;
        end

    // Transmit data
    if (start_bit) begin
        tx <= 0; //Start bit
        if (count == 0) begin
            start_bit <= 0;
            bit_counter <= 0;
        end
     end
    else begin
        if (bit_counter < 8) begin
            tx <= data[bit_counter];
            bit_counter <= bit_counter + 1;
        end
        else if (bit_counter == 8) begin
            tx <= 1; //Stop bit
            bit_counter <= bit_counter + 1;
        end
        else begin
            start_bit <= 1;
            bit_counter <= 0;
        end
     end
    end
end

        
endmodule