mcs /t:library libnodave.net.cs
mcs /r:libnodave.net.dll CS/testMPI.cs
mcs /r:libnodave.net.dll CS/testS7online.cs
mcs /r:libnodave.net.dll CS/simpleMPI.cs
mcs /r:libnodave.net.dll CS/simplePPI.cs
mcs /r:libnodave.net.dll CS/simpleISO_TCP.cs
mbas /r:./libnodave.net.dll VB/simpleMPI2.vb
