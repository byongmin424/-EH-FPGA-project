module uart_rx (
    input wire clk,
    input wire rst,
    input wire rx,
    output wire [7:0] received_data,
    output reg data_valid
);

// Parameters for UART configuration
parameter BAUD_RATE = 9600; // Set to the same baud rate as the transmitter

// Internal variables
reg [3:0] count;
reg [11:0] baud_counter;
reg [10:0] bit_counter;
reg start_bit;
reg [7:0] received_byte;

// Initialize variables
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        baud_counter <= 0;
        bit_counter <= 0;
        start_bit <= 1;
        received_byte <= 8'b0;
        data_valid <= 0;
    end
    else begin
        // Baud rate generation
        if (baud_counter == BAUD_RATE / 2 - 1) begin
            baud_counter <= 0;
            count <= count + 1;
        end
        else begin
            baud_counter <= baud_counter + 1;
        end

        // Receive data
        if (start_bit) begin
            if (rx == 0) begin
                // Start bit detected
                if (count == 0) begin
                    start_bit <= 0;
                    bit_counter <= 0;
                    received_byte <= 8'b0;
                end
            end
        end
        else begin
            if (bit_counter < 8) begin
                received_byte[bit_counter] <= rx;
                bit_counter <= bit_counter + 1;
            end
            else if (bit_counter == 8) begin
                // Stop bit detected
                bit_counter <= bit_counter + 1;
            end
            else begin
                // Process received data as needed
                received_data <= received_byte;
                data_valid <= 1;

                // Reset for the next byte
                start_bit <= 1;
                bit_counter <= 0;
            end
        end
    end
end

endmodule
