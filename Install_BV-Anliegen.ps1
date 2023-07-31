#Created by Fabian Keusen
#V1.0.1 Inital
#V1.1.0 Added Flavortext by Schötz

#Change These if you need to modify the behavior of the script
Write-Host "Installation Anliegen-DB" 
Write-Host ""
$targetpath = "C:\Daten" 
$sourcepath = "V:\anliegenDB" 
$file_naming = "BV-Anliegen.accdb"  #Some radical changes here might break things

$fullsourcepath = Join-Path -Path $sourcepath -ChildPath $file_naming

if(!(Test-Path -Path $fullsourcepath)){
    Write-Host ("Ursprungs Datei "+$file_naming+" nicht gefunden")
}else{
    $override = (Test-Path (Join-Path -Path $targetpath -ChildPath $file_naming)) #Bool Containing the information if the Copy will overwrite
    if(Test-Path -Path (Join-Path -Path $targetpath -ChildPath ($file_naming.split(".")[0]+".l"+$file_naming.split(".")[1]))){
        if((Read-Host "Datei ist geöffnet, trozdem Überschreiben ?(y/n)") -ne  "y"){
        quit}
    }
    Copy-Item -Path $fullsourcepath -Destination $targetpath
    if ($override){
    Write-Host "Datei wurde mit neuer Version überschrieben"
    }else{
    Write-Host "Datenbank wurde installiert"
    }
}
pause
