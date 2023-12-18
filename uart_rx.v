module uart_rx (
    input wire clk,
    input wire rst,
    input wire rx,  // UART 수신 신호
    output reg [7:0] received_data
);

parameter BAUD_RATE = 9600;

reg [3:0] count;
reg [11:0] baud_counter;
reg [10:0] bit_counter;
reg start_bit;
reg [7:0] shift_register;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        baud_counter <= 0;
        bit_counter <= 0;
        start_bit <= 1;
        shift_register <= 8'b0;
    end else begin
        // Baud rate generation
        if (baud_counter == BAUD_RATE / 2 - 1) begin
            baud_counter <= 0;
            count <= count + 1;
        end else begin
            baud_counter <= baud_counter + 1;
        end

        // Receive data
        if (start_bit) begin
            if (rx == 0) begin
                // Start bit detected
                start_bit <= 0;
                bit_counter <= 0;
            end
        end else begin
            if (bit_counter < 8) begin
                shift_register[bit_counter] <= rx;
                bit_counter <= bit_counter + 1;
            end else if (bit_counter == 8) begin
                // Stop bit detected
                received_data <= shift_register;
                start_bit <= 1;
            end
        end
    end
end

endmodule