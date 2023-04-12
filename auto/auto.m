import java.awt.Robot;
import java.awt.event.*;
vb = actxserver('wscript.shell');
% 创建 Robot 对象.
r = Robot;
% 移动鼠标至指定位置.
r.mouseMove(-1,-1);
pause(0.1);
% 按下回车键.
vb.SendKeys('{enter}');
pause(0.1);
% 从剪切板获取内容并粘贴.
vb.SendKeys('^v');
pause(0.1);