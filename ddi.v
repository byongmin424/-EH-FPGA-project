module ddi(
    input wire clk,
    input wire rst,
    input wire [7:0] Header,
    input wire [7:0] ImageData,
    input wire CheckSum,
    input wire Strb,
    output wire ddi_output // 예시 출력
);

// DDI 출력 로직 (이는 예시이며 실제 구현에 따라 다를 수 있음)
assign ddi_output = (Strb) ? ImageData : 8'b0;

endmodule
