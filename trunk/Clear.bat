@echo off

cd .\Source
del /s /a *.~*;*.dcu;*.stat;*.ddp

cd ..\Temp
del /s /a *.~*;*.dcu;*.ddp