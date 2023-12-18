module text_file_reader;
 reg [7:0] data [0:255]; // Assuming 256 bytes in the file
 integer i;

 initial begin
  // Read data from text file
  $readmemh("TestImage_2_.txt", data);

  // Display the read data
  $display("Data read from the file:");
  for (i = 0; i < 256; i = i + 1) begin
    $display("%h", data[i]);
   end
  end 
endmodule