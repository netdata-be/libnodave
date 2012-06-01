csc /t:library libnodave.net.cs
vbc /r:libnodave.net.dll VB/simpleMPI.vb
csc /r:libnodave.net CS/testMPI.cs
csc /r:libnodave.net CS/testS7online.cs

