// uart_rx.v
module uart_rx (
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] received_data,
    output reg DataRdy,
    output reg [7:0] Header,
    output reg [23:0] ImageData,
    output reg [7:0] CheckSum,
    output reg Strb
);

parameter BAUD_RATE = 9600;

reg [3:0] count;
reg [11:0] baud_counter;
reg [10:0] bit_counter;
reg start_bit;
reg [7:0] shift_register [23:0]; // 24-bit shift register
reg [23:0] received_byte; // Temporary storage for received byte

// State machine states
parameter IDLE = 2'b00;
parameter HEADER = 2'b01;
parameter DATA = 2'b10;
parameter CHECKSUM = 2'b11;
reg [1:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        baud_counter <= 0;
        bit_counter <= 0;
        start_bit <= 1;
        shift_register <= 24'b0; // Initialize as 0
        received_data <= 8'b0;
        DataRdy <= 0;
        Header <= 8'b0;
        ImageData <= 24'b0;
        CheckSum <= 8'b0;
        Strb <= 0;
        state <= IDLE;
    end else begin
        // Baud rate generation
        if (baud_counter == BAUD_RATE / 2 - 1) begin
            baud_counter <= 0;
            count <= count + 1;
        end else begin
            baud_counter <= baud_counter + 1;
        end

        // State machine
        case (state)
            IDLE: begin
                // Wait for start bit
                if (start_bit && (rx == 0)) begin
                    start_bit <= 0;
                    bit_counter <= 0;
                    state <= HEADER;
                end
            end

            HEADER: begin
                // Receive header byte
                if (bit_counter < 8) begin
                    shift_register[bit_counter] <= rx;
                    bit_counter <= bit_counter + 1;
                end else if (bit_counter == 8) begin
                    received_byte[0] <= shift_register;
                    Header <= received_byte[0];
                    bit_counter <= 0;
                    state <= DATA;
                end
            end

            DATA: begin
                // Receive image data bytes (RGB)
                if (bit_counter < 24) begin
                    shift_register[bit_counter] <= rx;
                    bit_counter <= bit_counter + 1;
                end else if (bit_counter == 24) begin
                    received_byte <= shift_register;
                    ImageData <= received_byte;
                    bit_counter <= 0;
                    state <= CHECKSUM;
                end
            end

            CHECKSUM: begin
                // Receive checksum byte
                if (bit_counter < 8) begin
                    shift_register[bit_counter] <= rx;
                    bit_counter <= bit_counter + 1;
                end else if (bit_counter == 8) begin
                    received_byte[0] <= shift_register;
                    CheckSum <= received_byte[0];
                    bit_counter <= 0;
                    state <= IDLE;
                    DataRdy <= 1;
                    Strb <= 1; // Set Strb signal to indicate valid data
                end
            end
        endcase
    end
end

endmodule
