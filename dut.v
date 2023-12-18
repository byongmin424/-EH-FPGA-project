module dut(
    input wire clk,
    input wire rst,
    input wire DataRdy,
    output reg [7:0] Header,
    output reg [7:0] ImageData,
    output reg CheckSum,
    output reg Strb
);

// Parameters
parameter IMAGE_WIDTH = 346;
parameter IMAGE_HEIGHT = 371;

// Internal variables
reg [15:0] counter;
reg [7:0] checksum_accumulator;

// Initialize
initial begin
    Header <= 8'b0;
    ImageData <= 8'b0;
    CheckSum <= 1'b0;
    Strb <= 1'b0;
    counter <= 16'b0;
    checksum_accumulator <= 8'b0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Header <= 8'b0;
        ImageData <= 8'b0;
        CheckSum <= 1'b0;
        Strb <= 1'b0;
        counter <= 16'b0;
        checksum_accumulator <= 8'b0;
    end else if (DataRdy) begin
        // Example logic for header, image data, checksum, and strobe signal
        Header <= {IMAGE_WIDTH[7:0], IMAGE_HEIGHT[7:0]}; // Sample header
        ImageData <= counter[7:0]; // Sample image data
        checksum_accumulator <= checksum_accumulator + ImageData;
        CheckSum <= checksum_accumulator;
        
        // Strobe signal logic
        Strb <= (counter[7:0] == 8'hFF) ? ~Strb : Strb;
        counter <= counter + 1;
    end
end

endmodule
