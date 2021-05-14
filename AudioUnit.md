# AudioUnit 


## 音频基础

声音的产生
声音是由物体振动产生的,是一种压力波,我们也可以称之为声波.
声波三要素: 频率,振幅,波形.
频率代表音频的高低,振幅代表响度,波形代表音色.

频率越高,波长就越短.低频的波比较长,更容易绕开障碍物,能量衰减小,声音传的远.
响度代表了能量的大小.
材质决定了音色的不同,波形也就不同.

人耳:20Hz -> 20KHZ


### 数字音频

采样->量化->编码

采样:在时间轴上对数字信号进行数字化.
奈奎斯特定理(采样定理):按比声音最高频率高2倍以上的频率对声音进行采样(AD转换)

量化:是指在幅度上对信号进行数字化,比如用16比特的二进制表示一个采样,所表示的范围就是[-32768，32767]，共有65536个可能取值，因此最终模拟的音频信号在幅度上也分为了65536层.


编码:


### 名词解释

一帧代表同一时刻的所有音频通道.
单声道 一帧有一个样本
双声道(立体声)
环绕立体声(多声道)

interleaved 交错的 (把多个声道放在一个流中,比如回放,希望同时读取多个声道)
noninterleaved 非交错的 (处理音频时比如添加效果或者信号处理,可以单独关注每个声道.)



一个CD的比特率计算:
采样率 44100 一秒44100的采样
比特率 2 * 44100 * 16 = 1411200bit/s

VBR 可变比特率 (提供一个数据块和一组数据包描述),帧的数据量可能不同,数据包的大小保持不变
CBR 恒定比特率 每帧的数据量是恒定的

PCM 具有恒定的比特率
压缩格式 通常使用可变比特率

## AudioUnit简介
AudioUnit是一个插件,可以加载到应用程序的进程中用于处理和生成音频,AudioUnit是AudioComponent类型,因此AudioComponent API是用于查找特定类型的AudioUnit,打开或关闭它们.


音频单元使用描述的一般概念来指定唯一实例。Type是音频单元的常规分类。SubType是由
音频单元的制造商（提供商）指定的不同标识符。Manufacturer就是Apple,见AudioComponentDescription.


AudioComponentDescription创建如下:

```
AudioComponentDescription audioDesc;
audioDesc.componentType = kAudioUnitType_Output;
audioDesc.componentSubType = kAudioUnitSubType_RemoteIO;
audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
audioDesc.componentFlags = 0;
audioDesc.componentFlagsMask = 0;
```

类型如下:

```
kAudioUnitType_Output                    = 'auou',
kAudioUnitType_MusicDevice                = 'aumu',
kAudioUnitType_MusicEffect                = 'aumf',
kAudioUnitType_FormatConverter            = 'aufc',
kAudioUnitType_Effect                    = 'aufx',
kAudioUnitType_Mixer                    = 'aumx',
kAudioUnitType_Panner                    = 'aupn',
kAudioUnitType_OfflineEffect            = 'auol',
kAudioUnitType_Generator                = 'augn',
```

## AudioUnit使用步骤

一个AuidioUnit的通常操作是:
- 打开一个AudioUnit(AudioComponentInstanceNew)
- 根据上下文进行配置 (AudioUnitSetProperty)
- 初始化AudioUnit (AudioUnitInitialize) (此时,audiounit处于可以渲染音频的状态)
- 渲染音频(AudioUnitRender)


音频单元渲染操作的一个重要部分是操作该单元提供的用于更改渲染效果的功能；例如，更改混响的衰减时间，滤波器的截止频率等。AudioUnitGetParameter和AudioUnitSetParameter用于与这些参数交互。


如果需要重新配置AudioUnit,需要:
- 取消初始化 (AudioUnitUninitialize)
- 根据上下文进行配置(AudioUnitSetProperty)
- 初始化AudioUnit (AudioUnitInitialize)

使用完AudioUnit,关闭
 - 关闭AudioUnit (AudioComponentInstanceDispose)


AudioUnit实际上是AudioComponentInstance,也可以理解为什么创建是通过AudioComponentFindNext先查找指定类型的AudioUnit,然后通过AudioComponentInstanceNew进行创建.

```
typedef AudioComponentInstance AudioUnit;
```

## AudioUnit的type
音频单元分为不同的类型，这些类型执行不同的角色和功能。


有一些通用的类别适用于不同类型的音频

1.实时使用。

音频单元将在比渲染所表示的时间更短的时间内完成其操作缓冲器。除OfflineEffect以外的所有音频单元都应符合此标准。

2.实时I/O。

将请求相同数量的音频输入，因为它被要求产生输出。Effects, Panners, Mixers 和 MusicDevices必须遵守这一限制。
FormatConverter可以在这种情况下使用（例如，sample速率转换，float -int），但音频单元的主机负责确保这个。

3.UI与编程使用

用户界面的使用包括在数字音频工作站(DAW)中使用具有适当用户界面的音频单元（例如GarageBand/Logic的filter) Effects、Panners、MusicDevices都应该可以在这种情况下使用。

编程用途是主机应用程序将音频单元用作通用信号处理链的一部分。

例如，Mixer音频单元可用于在游戏中获取多个不同的音频源并将它们混合在一起。Mixer、Output用于编程使用。FormatConverter和Generator类型通常是编程音频单元，但是如果它们可以在UI环境中使用，它们将指定一个自定义视图。然后应用程序可以使用它来决定，在适当的限制下，音频单元可以在DAW类型的应用程序中呈现。例如，苹果公司的AUConverter音频单元可以进行采样率转换等，但对于DAW应用程序中的用户来说没有通用工具。苹果的Varispeed或AUTimePitch音频单元可以用来改变播放速率和音高，因此可以在DAW类型的环境中被用户用来产生良好的效果，也可以为任何程序提供这种通用功能。

注:DAW （Digital Audio Workstation），即数字音频工作站——是一种用于录音、混音、音频剪辑以及数字音频处理的软件（也有硬件单元，但是不常见）。常见的DAW软件有Ableton Live、Pro Tools、Logic、GarageBand、 Audacity以及Reaper等等。


## AudioUnit的type

kAudioUnitType_Output
一个输出单元可以单独使用，也可以作为一个AUGraph或AVAudioEngine的一部分。苹果提供许多直接与音频设备接口的输出单元。

kAudioUnitType_MusicDevice
一种软件乐器，如采样器或合成器。它们响应MIDI并创建音符，然后通过参数或MIDI控制消息来控制音符。
详见<AudioToolbox/MusicDevice.h>

kAudioUnitType_MusicEffect
一种也能直接响应MIDI控制信息的特效，通常是通过将这些MIDI信息映射到特效的DSP算法的不同参数。

kAudioUnitType_FormatConverter
音频单元的通用类别，它可以将格式（例如，采样率转换）从输入更改为输出，以及其他非I/O类型的操作（如延迟渲染或varispeed类型的操作）。因此，格式转换器可以要求尽可能多或尽可能少的音频输入来产生给定的输出。它们仍然需要在输出缓冲区表示的时间内完成渲染。

对于具有“音频效果或处理器”实用程序的格式转换器，提供此音频单元的脱机版本也很常见。例如，苹果提供了一个格式转换器（用于“实时”情况）和一个离线版本（用于处理音频文件）的时距和Varispeed音频单元。

kAudioUnitType_Effect
一种音频单元，它将处理x个数的音频输入样本以产生x个数的音频输出样本。一种效果的常见情况是将一个输入转换为一个输出，尽管有些效果也采用边链输入。效果可以在“脱机”上下文中运行（例如处理文件），但它们需要实时运行。延迟单元或混响就是一个很好的例子。

kAudioUnitType_Mixer
一种音频单元，它接收一定数量的输入信号，并将它们混合以提供一个或多个音频输出。立体声混音器（单声道和立体声输入产生一个立体声输出）就是一个例子。

kAudioUnitType_Panner
平移器是一种专门的效果，它可以将单个音频输入平移到单个输出。平移器单元需要支持指定平移坐标的标准化参数集合（除了平移器可能提供的任何自定义参数）。A surround panner就是一个例子


kAudioUnitType_Generator
没有音频输入，但只产生音频输出。在某些方面，它与音乐设备类似，只是生成器不提供MIDI输入或“音符”的概念。音调发生器A tone generator就是一个很好的例子。
                    
kAudioUnitType_OfflineEffect
用于处理文件中的数据，也用于发布无法实时运行的功能。例如，标准化过程要求在可以估计标准化过程中应用的标量之前查看整个音频输入。因此，离线效果还有一个启动阶段的概念，可以在执行实际的渲染/处理阶段之前执行。


kAudioUnitType_MIDIProcessor
这类插件处理MIDI输入并产生MIDI输出。它们不产生音频。

## AudioUnit的SubType

常用五种类型

### 1.Effect

kAudioUnitSubType_NBandEQ
均衡效果器：主要作用是为声音的某些频带增强或者减弱能量，该效果器需要指定多个频带，然后为各个频带设置宽度以及增益，最终将改变声音在频域上的能量分布。

kAudioUnitSubType_DynamicsProcessor
压缩效果器：主要作用是当声音较小的时候可以提高声音的能量，当声音的能量超过了设置的阈值时，可以降低声音的能量，当然应合理地设置作用时间、释放时间以及触发值，使得最终可以将声音在时域上的能量压缩到一定范围之内。

kAudioUnitSubType_Reverb2
混响效果器：对于人声处理来讲这是非常重要的效果器，可以想象自己身处在一个空房子中，如果有非常多的反射声和原始声音叠加在一起，那么从听感上可能会更有震撼力，但是同时原始声音也会变得更加模糊，原始声音的一些细节会被遮盖掉，所以混响设置的大或者小对于不同的人来讲会很不一致，可以根据自己的喜好来进行设置。

Effect Unit下最常使用的就是上述三种效果器，当然其下还有很多种子类型的效果器，像高通（High Pass）、低通（Low Pass）、带通（Band Pass）、延迟（Delay）、压限（Limiter）等效果器.

### 2.Mixer Units

kAudioUnitSubType_MultiChannelMixer
MultiChannelMixer：它是多路声音混音的效果器，可以接收多路音频的输入，还可以分别调整每一路音频的增益与开关，并将多路音频合并成一路，该效果器在处理音频的图状结构中非常有用。


### 3.OutPut 也就是I/O Unit
主要提供的就是I/O的功能

kAudioUnitSubType_RemoteIO
RemoteIO：用来采集音频与播放音频的，应用场景中要使用麦克风及扬声器的时候会用到该AudioUnit。

kAudioUnitSubType_GenericOutput
Generic Output：当开发者需要进行离线处理，或者说在AUGraph中不使用Speaker（扬声器）来驱动整个数据流，而是希望使用一个输出（可以放入内存队列或者进行磁盘I/O操作）来驱动数据流时，就使用该子类型。

### 4.Format Converter Units

类型是kAudioUnitType_FormatConverter，主要用于提供格式转换的功能，比如：采样格式由Float到SInt16的转换、交错和平铺的格式转换、单双声道的转换等，其子类型及用途说明如下。

kAudioUnitSubType_AUConverter
AUConverter：格式转换效果器，当某些效果器对输入的音频格式有明确的要求时（比如3D Mixer Unit就必须使用UInt16格式的sample），或者开发者将音频数据输入给一些其他的编码器进行编码，又或者开发者想使用SInt16格式的PCM裸数据在其他CPU上进行音频算法计算等的场景下，就需要使用到这个ConverterNode了。下面来看一个比较典型的场景，自定义一个音频播放器，由FFmpeg解码出来的PCM数据是SInt16格式的，因此不能直接输送给RemoteIO Unit进行播放，所以需要构建一个ConvertNode将SInt16格式表示的数据转换为Float32格式表示的数据，然后再输送给RemoteIO Unit，最终才能正常播放出来。

kAudioUnitSubType_NewTimePitch
Time Pitch：即变速变调效果器，这是一个很有意思的效果器，可以对声音的音高、速度进行调整，像“会说话的Tom猫”类似的应用场景就可以使用这个效果器来实现。

### 5.Generator Units

类型是kAudioUnitType_Generator，在开发中我们经常使用它来提供播放器的功能。其子类型及用途说明如下。

kAudioUnitSubType_AudioFilePlayer
AudioFilePlayer：在AudioUnit里面，如果我们的输入不是麦克风，而希望其是一个媒体文件，AudioFilePlayer作为输入数据源来提供数据的.


## AVAudioEngine

