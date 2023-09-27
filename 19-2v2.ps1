cd C:\Daten\2015

#CYK algorithm implementation
#CYK Requires the  Chomsky normal form, and that would need a lot of overhead

$myinput = Get-Content -Path .\19-1.txt
#$myinput = Get-Content -Path .\19-1-1.txt

$medicine = $myinput[-1]
$rmolecules= @(($medicine.substring(0,1).toupper() + $medicine.substring(1) -creplace '[A-Z]', ' $&').Trim();)
$rmolecules[0] = -split $rmolecules[0]

$replacements = @()
0..($myinput.Length-3)|%{
    $replacements += ,@($myinput[$_] -split " => ")
}

$replacements = $replacements | sort { [int]$_[1].length} -Descending #Gives the Algorithem a greedy aproach

$break = $false #Debugger
while($rmolecules[-1][0] -ne 'e' -and -not $break){
    #Write-Host "Reducing Lenght $($rmolecules[-1].Length)"
    $rmolecules+= ,@()
    #Try all possible replacements
    :replacement foreach($replacement in $replacements){
        $tomatch = -split (($replacement[1].substring(0,1).toupper() + $replacement[1].substring(1) -creplace '[A-Z]', ' $&').Trim())

        #Write-Host "Looing for $($tomatch)"
        #Try all possible positions
        0..($rmolecules[-2].Length -($tomatch.Length +1))|%{
            $fullmatch = $true
            #Test if all sections of the replacement output match
            :match for($i = 0;$i -lt $tomatch.Length;$i++){
                if($tomatch[$i] -ne $rmolecules[-2][$_+$i]){
                    $fullmatch = $false
                    break match
                }
            }
            #The pattern matches, we can replace it
            if($fullmatch){
                #Write-Host "Match at index: $($_)"
                if($_ -ne 0){
                    $rmolecules[-1]  = $rmolecules[-2][0..($_-1)]
                }
                    $rmolecules[-1] += $replacement[0]
                if(($rmolecules[-2].Length-1) -gt ($_+($tomatch.Length))){
                    $rmolecules[-1] += $rmolecules[-2][($_+($tomatch.Length))..($rmolecules[-2].Length-1)]
                }
                #Write-Host "Reduced with $($replacement)"
                break replacement
            }#else{Write-Host "Nomatch"}
        }
    }
    if($rmolecules[-1].Length -gt $rmolecules[-2].Length){$break = $true;Write-Host "`nGot longer"}
    if($rmolecules[-1].Length -eq 1){$break = $true;Write-Host "`nDid not Reach E"}
    if($rmolecules[-1].Length -eq 0){$break = $true;Write-Host "`nVoid"}
}
$rmolecules[-1]
Write-Host "Completed"