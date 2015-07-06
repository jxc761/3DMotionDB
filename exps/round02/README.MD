## 实验简介：

目前，我们已经有如下工作基础如：

* 一个小的物体数据库：一共有23个SketchUp物体模型。 
* 一个相对完备的工具集：该工具集可以将object组成不同的场景；给定camera位置，可以自动对焦并生成指定相机运动轨迹；并且可以用maxwell对此进行渲染。

然而，以物体数据库为输入，借助已有工具集，生成图像序列，我们还需要设定如下参数：

* 地面材质
* 光照环境
* 相机拍摄参数
* 每个场景中的物体数量

因此，round02的实验目的就是探索这些参数。


## 相机拍摄参数

The Maxwell Render camera is designed to work like a real camera。 所以我们依据真实物理相机参数，对maxwell的相机参数做了如下设定。

<table>
<tr> <td>Parameter</td> <td> Value </td> </tr>
<tr> <td>ISO</td> <td> 100 </td> </tr>
<tr> <td>fstop</td> <td> 5.6 </td> </tr>
<tr> <td>shutter</td> <td> 60 (/s) </td> </tr>
<tr> <td> focal length</td> <td> 50mm </td> </tr>
<table> 



## 光照环境测试实验

Constant Dome只是对sky condition的一种简单近似，physical sky的参数又很难获取准确的，相对而言HDR算是一种比较好的光照环境选择。



** 实验实录 **
总的来说，用Maxwell Render进行渲染，Environment设定物理光照环境，相机的ISO，EV，fstop，shutter则影响最终的曝光度。因为可以从网络上找到免费的sky文件，Maxwell Render也提供了几个测试的sky文件，所以最初的想法是想找到各种关照条件的下，最优的ISO，所以进行了run01实验。但是根据导师的意见，修改为固定ISO，寻找合适的sky设定。


** 待办事项 **

1. 整理现有实验结果
2. HDR文件的技术细节
3. 收集整理一个HDR数据库


## 地面材质测试实验

### 测试场景

本次试验我们将用到两个场景。其中第一个场景为一个简单的室外物体拍摄场景，该场景沿用光照测试实验中的设置，我们希望找满足我们视觉需要的材质。另一个场景为标准材质测试场景，我们试图通过该场景来测试材质的收敛速度，以排除收敛速度过慢的材质。

	
### 候选材质

The collection, Arroway Textures Edition 1, contains 102 professional multi-layered textures in highest resolutions of up to 60 megapixels. Nearly every texture consists of diffuse-, bump and specular/glossiness map - all available in lossless-compressed format (PNG24 / PNG8).

The collection covers textures of the following categories: Boards/Wood, Bricks/Walls, Concrete, Metal, Pavement, Plaster, Stone, Tiles and Misc.


** Specifications **

* 4.1GB total size
* 102 multi-layered textures
* Textures consisting of diffuse, specularity and bump map (288 maps total)
* Almost all textures are tilable
* All maps come as lossless compressed PNG files
* Printer-friendly texture catalog (PDF format)
* Ready-to-use material setups for MaxwellRender™ 2.x



** Details **
<table> 
<tr> <td>type</td> 				<td>number	</td> </tr>
<tr> <td>board</td> 			<td>5		</td> </tr>
<tr> <td>bricks</td> 			<td>20		</td> </tr>
<tr> <td>concrete</td> 			<td>3		</td> </tr>
<tr> <td>metal structure</td> 	<td>7		</td> </tr>
<tr> <td>metal lattice</td> 	<td>1		</td> </tr>
<tr> <td>metal plate</td> 		<td>5		</td> </tr>
<tr> <td>pavement</td> 			<td>6		</td> </tr>
<tr> <td>plaster</td> 			<td>26		</td> </tr>
<tr> <td>stone</td> 			<td>3		</td> </tr>
<tr> <td>tiles</td> 			<td>20		</td> </tr>
<tr> <td>misc</td> 				<td>6		</td> </tr>
</table>




### 选择标准

* 不要有太强的反光性，因为这会带来复杂的运动信息
* 尽量避免displacement材质，因为这会带来虚假三维信息
* 需要有一定的纹理来提供基本的运动信息
* 材质渲染的收敛速度要尽量快


### 实验步骤


### 实验结果

### 总结
总的来说，Arroway提供的材质，质量很好，其中一点就是有纹理的真实尺度信息。另一个优点再于，有提供Maxwell Render的材质设定。其三，经过测试，收敛的速度也比较快。目前挑出来的53种seamless材质看上均可以用。






