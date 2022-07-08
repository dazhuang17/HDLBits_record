# Circuits -> Sequential Logic -> Finite State Machines

## 0 写在前面
- [119-127](./readme_0.md)
- [128-134](./readme_1.md)
- [135-141](./readme_2.md)
- [142-151](./readme_3.md)

## 135 Serial receiver
<details>
<summary>详情</summary>

在许多（较旧的）串行通信协议中，每个数据字节都与一个起始位和一个停止位一起发送，以帮助接收器从位流中划定字节。
一种常见的方案是使用 1 个起始位 (0)、8 个数据位和 1 个停止位 (1)。当没有传输任何内容（空闲）时，该线路也处于逻辑 1。  
设计一个有限状态机，当给定比特流时，它将识别何时正确接收到字节。
它需要识别起始位，等待所有 8 个数据位，然后验证停止位是否正确。
如果停止位未按预期出现，则 FSM 必须等到找到停止位后再尝试接收下一个字节。  

![](./images/12.jpg)  

**分析**  
多设置几个状态。  
唯一需要注意的是`done`的触发条件，以及`滞后一个时间周期`。

**答案**  
```
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    parameter error=4'd0,
    		  data_0=4'd1,
    		  data_1=4'd2,
    		  data_2=4'd3,
    		  data_3=4'd4,
    		  data_4=4'd5,
    		  data_5=4'd6,
    		  data_6=4'd7,
    		  data_7=4'd8,
    		  stop=4'd9,
    		  idle=4'd10;
    
    reg [3:0] state,next_state;
    
    always @(*) begin
        case(state)
            error: next_state = in ? idle : error;
            data_0 : next_state = data_1;
            data_1 : next_state = data_2;
            data_2 : next_state = data_3;
            data_3 : next_state = data_4;
            data_4 : next_state = data_5;
            data_5 : next_state = data_6;
            data_6 : next_state = data_7;
            data_7 : next_state = stop;
            stop : next_state = in ? idle : error;
            idle : next_state = in ? idle : data_0;
            default: next_state = idle;
        endcase
    end
    
    always @(posedge clk)begin
        if (reset) state <= idle;
        else state <= next_state;
    end
    
    reg temp;
    always @(posedge clk)begin
        if (state==stop) begin 
            if(next_state==idle) temp <= 1'b1;
            else temp <= 1'b0;
        end
        else temp <= 1'b0;
    end
    
    assign done = temp;
          
endmodule
```

</details>

## 136 Serial receiver and datapath
<details>
<summary>详情</summary>

`done`的时候输出对应的`data`。  

![](./images/13.jpg)   

**分析**  
和134的想法2类似。  
注意一下传入的数据是高位还是低位即可。  

**答案**  
```
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

parameter error=4'd0,
    		  data_0=4'd1,
    		  data_1=4'd2,
    		  data_2=4'd3,
    		  data_3=4'd4,
    		  data_4=4'd5,
    		  data_5=4'd6,
    		  data_6=4'd7,
    		  data_7=4'd8,
    		  stop=4'd9,
    		  idle=4'd10;

    reg [3:0] state,next_state;

    always @(*) begin
        case(state)
            error: next_state = in ? idle : error;
            data_0 : next_state = data_1;
            data_1 : next_state = data_2;
            data_2 : next_state = data_3;
            data_3 : next_state = data_4;
            data_4 : next_state = data_5;
            data_5 : next_state = data_6;
            data_6 : next_state = data_7;
            data_7 : next_state = stop;
            stop : next_state = in ? idle : error;
            idle : next_state = in ? idle : data_0;
            default: next_state = idle;
        endcase
    end

    always @(posedge clk)begin
        if (reset) state <= idle;
        else state <= next_state;
    end

    reg temp;
    always @(posedge clk)begin
        if (state==stop) begin
            if(next_state==idle) temp <= 1'b1;
            else temp <= 1'b0;
        end
        else temp <= 1'b0;
    end
    
    reg [9:0] data;
    always @(posedge clk)begin
        if (reset) data <= 10'b0;
        else data <= {in, data[9:1]};
    end

    assign done = temp;
    assign out_byte = temp ? data[8:1] : out_byte;

endmodule
```

</details>

## 137 Serial receiver with parity checking
<details>
<summary>详情</summary>

我们想为串行接收器添加奇偶校验。奇偶校验在每个数据字节后增加一位。
我们将使用奇校验，其中接收到的 9 位中的 1 的数量必须是奇数。
例如，101001011 满足奇校验（有 5 个 1），但 001001011 不满足。  
只有当一个字节被正确接收并且它的奇偶校验通过时，才断言完成信号。
与串行接收器 FSM 一样，此 FSM 需要识别起始位，等待所有 9 个（数据和奇偶校验）位，然后验证停止位是否正确。
如果停止位未按预期出现，则 FSM 必须等到找到停止位后再尝试接收下一个字节。  
 
![](./images/14.jpg)  

**分析**  
首先，没看懂奇偶校验模块，我自己写的一个校验。  
对9位数据进行异或运算。  
注意，进行奇偶校验的时候，9位数据在data的哪一段位置。  

**答案**  
```
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    parameter error=4'd0,
              data_0=4'd1,
              data_1=4'd2,
              data_2=4'd3,
              data_3=4'd4,
              data_4=4'd5,
              data_5=4'd6,
              data_6=4'd7,
              data_7=4'd8,
              check=4'd11,
              stop=4'd9,
              idle=4'd10;

    reg [3:0] state,next_state;

    always @(*) begin
        case(state)
            error: next_state = in ? idle : error;
            data_0 : next_state = data_1;
            data_1 : next_state = data_2;
            data_2 : next_state = data_3;
            data_3 : next_state = data_4;
            data_4 : next_state = data_5;
            data_5 : next_state = data_6;
            data_6 : next_state = data_7;
            data_7 : next_state = check;
            check: next_state = stop;
            stop : next_state = in ? idle : error;
            idle : next_state = in ? idle : data_0;
            default: next_state = idle;
        endcase
    end

    always @(posedge clk)begin
        if (reset) state <= idle;
        else state <= next_state;
    end

    reg temp;
    always @(posedge clk)begin
        if (state==stop) begin
            if(next_state==idle) begin
                if (^data[10:2] == 1'b1)
                	temp <= 1'b1;
            	else temp <= 1'b0;
            end
            else temp <= 1'b0;
        end
        else temp <= 1'b0;
    end

    reg [10:0] data;
    always @(posedge clk)begin
        if (reset) data <= 10'b0;
        else data <= {in, data[10:1]};
    end

    assign done = temp;
    assign out_byte = temp ? data[8:1] : out_byte;

endmodule
```

</details>

## 138 Sequence recognition
<details>
<summary>详情</summary>

同步 HDLC 成帧涉及对数据的连续比特流进行解码，以寻找指示帧（数据包）开始和结束的比特模式。
恰好看到 6 个连续的 1（即 01111110）是指示帧边界的“标志”。
为避免数据流意外包含“标志”，发送方在每 5 个连续的 1 后插入一个零，接收方必须检测并丢弃该 0。
如果有 7 个或更多连续的 1，我们还需要发出错误信号。  

创建一个有限状态机来识别这三个序列：
- 0111110：需要丢弃信号位（disc）。
- 01111110：标记帧的开始/结束（flag）。
- 01111111...：错误（7 个或更多 1s）（err）。  
当 FSM 被重置时，它应该处于一个状态，就像之前的输入为 0 一样。  

![](./images/15.jpg)  

**分析**  
好像没有办法弄一个空闲状态。。。  
现`data_0`状态检测判断第一个数据位。  

**答案**  
```
module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    
    parameter error=4'd0,
              data_0=4'd1,
              data_1=4'd2,
              data_2=4'd3,
              data_3=4'd4,
              data_4=4'd5,
              data_5=4'd6,
              data_6=4'd7,
              data_7=4'd8,
              dis=4'd9,
    		  fla=4'd12,
              idle=4'd10;
    
    reg [3:0] state,next_state;
    always @(*) begin
        case(state)
            //idle: next_state = in ? idle : data_0;
            data_0 : next_state = in ? data_1 : data_0;
            data_1 : next_state = in ? data_2 : data_0;
            data_2 : next_state = in ? data_3 : data_0;
            data_3 : next_state = in ? data_4 : data_0;
            data_4 : next_state = in ? data_5 : data_0;
            data_5 : next_state = in ? data_6 : dis;
            data_6 : next_state = in ? error : fla;
            fla : next_state = in ? data_1 : data_0;
            dis : next_state = in ? data_1 : data_0;
            error : next_state = in ? error : data_0;
            default: next_state = data_0;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) state <= data_0;
        else state <= next_state;
    end
    
    assign disc = (state==dis);
    assign flag = (state==fla);
    assign err = (state==error);
      
endmodule
```

</details>

## 139 Design a Mealy FSM
<details>
<summary>详情</summary>

实现一个 Mealy 型有限状态机，它可以识别名为 x 的输入信号上的序列“101”。
您的 FSM 应该有一个输出信号 z，当检测到“101”序列时，它被断言为逻辑 1。
您的 FSM 还应该有一个低电平有效的异步复位。您的状态机中可能只有 3 个状态。
您的 FSM 应该能够识别重叠序列。  

**分析**  
想法1（success）：  
没有通过状态机
正常来说所得`z`的值比正确值晚一拍。。。  
正确对比所需的三比特即可。（说到底还是时序问题）  
想法2（success）：  
使用状态机  
判断顺序`1 -> 2 -> 3 -> 2/1`  
`z`置高仅在`3为1`时。


**答案**  
想法1：  
```
module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
    
    reg [2:0] temp;
    always @(posedge clk or negedge aresetn) begin
        if(~aresetn) temp <= 3'b0;
        else temp <= {temp[1:0], x};
    end

    assign z = x&temp[1]&~temp[0];

endmodule
```

想法2：  
```
module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
    
    parameter A = 2'b00, B = 2'b01, C = 2'b10;
    reg [1:0] state, next_state;
    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = x ? B : C;
            C: next_state = x ? B : A;
            default: next_state = A;
        endcase
    end
    
    always @(posedge clk or negedge aresetn) begin
        if (~aresetn) state <= A;
        else state <= next_state;
    end

    assign z = (state == C ? x : 1'b0);

endmodule

```

</details>

## 140 Serial 2s complementer - Moore FSM
<details>
<summary>详情</summary>

你要设计一个单输入单输出串行 2 的补码摩尔状态机。
输入 (x) 是一系列位（每个时钟周期一个），从数字的最低有效位开始，输出 (Z) 是输入的 2 的补码。
机器将接受任意长度的输入数字。该电路需要异步复位。转换在释放复位时开始，在复位时停止。  

![](./images/16.jpg)  

**分析**  
有点懵。。。  

**答案**  
```

```

</details>

## 141 Serial 2s complementer - Mealy FSM
<details>
<summary>详情</summary>

下图是 2 的补码的 Mealy 机器实现。使用 one-hot 编码实现。  

![](./images/17.jpg)  

**分析**  
抱拳了。  

**答案**  
```

```

</details>
