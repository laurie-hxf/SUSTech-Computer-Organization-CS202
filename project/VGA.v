`include "define.v"

module vga (//640 480 60Hz
    input clk,
    input rst,
    input [7:0] tempt1,
    input [7:0] tempt2,

    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue,
    output hsync,
    output vsync,
    output rgb_valid
);

wire vga_clk;

clk_wiz_0 clk_inst(
      .clk_in1(clk),
      .clk_out1(vga_clk) //need exact 25 MHz
);


reg [159:0] numbers[19:0];// "0123456789abcdef" 16 char (10 pix w ,20 pix h)
always@(posedge vga_clk) begin
    numbers[0]  <= 160'h0000000000000000000000000000000000000000;//40*4
    numbers[1]  <= 160'h0000000000000000000000000000000000000000;
    numbers[2]  <= 160'h0000000000000000000000000000000000000000;
    numbers[3]  <= 160'h0000000000000000000000000000000000000000;
    numbers[4]  <= 160'h0000000000000000000000000000000000000000;
    numbers[5]  <= 160'h060000000000000020000C000000000000000000;
    numbers[6]  <= 160'h1F8183F0FC030FC0C1FE3307C001800000C00070;
    numbers[7]  <= 160'h39838210040508010006618C6001800000C00050;
    numbers[8]  <= 160'h3187861804090802000C63186001800000C000C0;
    numbers[9]  <= 160'h618D0010181908060008361061C1701C07C1C080;
    numbers[10] <= 160'h618100307C310FC5F8181E106731CC3309C233E0;
    numbers[11] <= 160'h61810060066308660C103399C4118C6018C41080;
    numbers[12] <= 160'h618100C00243C0240C10408641F1844010C62080;
    numbers[13] <= 160'h63810180027F0024083040C046118C4010C5C080;
    numbers[14] <= 160'h3F0106798E0310661820618044318C6310C61080;
    numbers[15] <= 160'h1E010780F8031FC1E0201F0043F1F83E0FC3E0C0;
    numbers[16] <= 160'h0000000000000000002000000000000000000000;
    numbers[17] <= 160'h0000000000000000000000000000000000000000;
    numbers[18] <= 160'h0000000000000000000000000000000000000000;
    numbers[19] <= 160'h0000000000000000000000000000000000000000;
end

reg [9:0] h_cnt;
always @(posedge vga_clk) begin
    if (rst) h_cnt <= 0;
    else if (h_cnt == `H_CYCLE - 1) h_cnt <= 0;
    else h_cnt <= h_cnt + 1;
end

reg [9:0] v_cnt;
always @(posedge vga_clk) begin
    if (rst) v_cnt <= 0;
    else if (v_cnt == `V_CYCLE - 1) v_cnt <= 0;
    else if (h_cnt == `H_CYCLE - 1) v_cnt <= v_cnt + 1;
    else v_cnt <= v_cnt;
end

assign hsync = (h_cnt < `H_SYNC - 1) ? 1 : 0 ;
assign vsync = (v_cnt < `V_SYNC - 1) ? 1 : 0 ;

assign rgb_valid = (((h_cnt >= `H_SYNC + `H_BACK + `H_LEFT)
                  && (h_cnt < `H_SYNC + `H_BACK + `H_LEFT + `H_ACTIVE))
                  &&((v_cnt >= `V_SYNC + `V_BACK + `V_TOP)
                  && (v_cnt < `V_SYNC + `V_BACK + `V_TOP + `V_ACTIVE))) ? 1 : 0;


reg[15:0] index_x,index_y;

always@(*)begin
    if(rst)begin
        index_x <= 1'b0;
        index_y <= 1'b0;
    end
    else begin
      index_x <= (rgb_valid == 1'b1) ? (h_cnt - (`H_SYNC + `H_BACK + `H_LEFT)) : 0;
      index_y <= (rgb_valid == 1'b1) ? (v_cnt - (`V_SYNC + `V_BACK + `V_TOP)) : 0;
    end
end


always @(*) begin
    if (rst) begin
        {red, green, blue} <= 0;
    end 
    else if (rgb_valid) begin
        // start from (100,100) cover (80,20), which is 8 bits,write tempt1
        if (index_y >= 100 && index_y < 120) begin 
            if (index_x >= 100 && index_x < 180) begin
                if (numbers[index_y - 100][(159 - tempt1[7 - (index_x - 100) / 10] * 10) - (index_x - 100) % 10] == 1'b1) begin
                    {red, green, blue} <= 12'hFFF; // white
                end else begin
                    {red, green, blue} <= 12'h000;
                end
            end else begin
                {red, green, blue} <= 12'h000;
            end
        end 
        // start from (100,120) cover (80,20), which is 8 bits,write tempt2
        else if (index_y >= 120 && index_y < 140) begin 
            if (index_x >= 100 && index_x < 180) begin
                if (numbers[index_y - 120][(159 - tempt2[7 - (index_x - 100) / 10] * 10) - (index_x - 100) % 10] == 1'b1) begin
                    {red, green, blue} <= 12'hFFF; // white
                end else begin
                    {red, green, blue} <= 12'h000;
                end
            end else begin
                {red, green, blue} <= 12'h000;
            end
        end
        //default case
        else begin
            {red, green, blue} <= 12'h000;
        end

    end else begin
        {red, green, blue} <= 12'h000;
    end
end


endmodule
