module vga (
    clk,
    rstn,
    Signal,
    HS,
    VS,
    blk,
    Data
);
    input clk;
    input rstn;
    input [23:0]Signal;
    output HS;
    output VS;
    output blk;
    output [23:0] Data;
//H
parameter HS_max = 96;
parameter H_Back_Porch = 40;
parameter Left_Border = 8;
parameter Right_Border = 8;
parameter H_Front_Porch = 8;
//V
parameter VS_max = 2;
parameter V_Back_Porch = 25;
parameter Top_Border = 8;
parameter Botton_Border = 8;
parameter V_Front_Porch = 2;
//Data_Valid
parameter H_Data_Valid = 640;
parameter V_Data_Valid = 480;

reg [9:0] HS_count;
always @(posedge clk or negedge rstn) begin
    if(!rstn)
        HS_count <= 10'b0;
    else if(HS_count == HS_max+H_Back_Porch+Left_Border+H_Data_Valid+Right_Border+H_Front_Porch-1)
        HS_count <= 10'b0;
    else
        HS_count <=HS_count +1'b1;
end

reg [9:0] VS_count;
always @(posedge clk or negedge rstn) begin
    if(!rstn)
        VS_count <= 10'b0;
    else if(HS_count == HS_max+H_Back_Porch+Left_Border+H_Data_Valid+Right_Border+H_Front_Porch-1)begin
        if(VS_count == VS_max+V_Back_Porch+Top_Border+V_Data_Valid+Botton_Border+V_Front_Porch-1)
            VS_count <= 10'b0;
        else    VS_count <=VS_count +1'b1;
    end
    else    
        VS_count <=VS_count;
end

assign HS = (HS_count < HS_max)?1:0;
assign VS = (VS_count < VS_max)?1:0;
assign blk = ((HS_count >= HS_max+H_Back_Porch+Left_Border)&&(HS_count <  HS_max+H_Back_Porch+Left_Border+H_Data_Valid)&&(VS_count >= VS_max+V_Back_Porch+Top_Border)&&(VS_count <VS_max+V_Back_Porch+Top_Border+V_Data_Valid))?1:0;
assign Data = blk?Signal:0;
endmodule //vga