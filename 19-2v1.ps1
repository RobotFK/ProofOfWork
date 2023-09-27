cd C:\Daten\2015

#Others have failed at this, so I will need some optimisation to keep some sanity

#CYK algorithm maybe instead ?

$myinput = Get-Content -Path .\19-1.txt
$medicine = $myinput[-1]
$rmolecules= @($medicine)
$molecule= @("e")

function Substitute-substring{
    param(
    [int]$i, #index
    [string]$torep, #String to replace
    [string]$replacement,
    [string]$old
    )
    $new = ""
    if($i -ne 0){
        $new += $old.Substring(0,$i)
    }
    $new += $replacement
    #Write-Host $new
    if($old.Length -ne $i+$torep.Length){
        $new += $old.Substring($i+($torep.Length))
    }
    return $new
}

$replacementins = @() #Array of Strings that can be transformed
$replacements = @()
0..($myinput.Length-3)|%{
    $replacements += ,@($myinput[$_] -split " => ")
    $in = ($myinput[$_] -split " => ")[0]
    if($in -notin $replacementins){$replacementins += $in}
}

$onlyouts = @() #Array of Strings that can be created but not transformed, meaning they are permament
$replacements|%{
    $fullout = $_[1]
    for($i = 0;$i -lt ($fullout.length-2);$i++){
        if($fullout[$i] -in $replacementins){}
        elseif(($fullout[$i]+$fullout[$i+1]) -in $replacementins){$i++}
        else{
         #Reaching here means that we found a combination of 1-2 Letters that contain a onlyout segement
            if($fullout[$i+1] -cmatch “[A-Z]”){#Second letter is Uppercase, so only the first letter is important
                $out = $fullout[$i]
            }else{$out = ($fullout[$i]+$fullout[$i+1])}
            if($out -notin $onlyouts){$onlyouts+=$out}
        #Write-Host "$($fullout[$i]+$fullout[$i+1]) possible"
        }
    }
}
Write-Host "Presolving: $($onlyouts)"
foreach($onlyout in $onlyouts){
    $replaceindexes = (Select-String -InputObject $rmolecules[-1] -Pattern $onlyout+"(?![a-z])" -AllMatches -CaseSensitive).Matches.Index
    $replacementsubset = $null #List of all replacements that ateast contain the Target String
    $replacements|%{if($_[1] -cmatch $onlyout){$replacementsubset+=,@($_)}}
    Write-Host "$($onlyout): $($replacementsubset.Length)"  
    if($replacementsubset -eq $null){continue}
    $replaceindexes|%{
    }
}

#Main loop:
while('e' -notin $rmolecules[-1]){
    Write-Host "Reducing $($rmolecules[-1].Length) options"
    #Iterate each Molecule of the last group
    $rmolecules+= ,@()
    :molecule foreach($molecule in $rmolecules[-2]){
        #Iterate over each replacement
        :replacement foreach($replacement in $replacements){
            $replaceindexes = (Select-String -InputObject $molecule -Pattern $replacement[1] -AllMatches -CaseSensitive).Matches.Index
            if($replaceindexes.length -eq 0){ continue replacement}
            #Write-Host "$($replacement[1]): $($replaceindexes)"
            $replaceindexes|%{
                $testmol = Substitute-substring $_ $replacement[1] $replacement[0] $molecule
                if($testmol -notin $rmolecules[-1]){$rmolecules[-1] += $testmol}
            }
        }
    }
#If Reduction is not in the next group,add it
}

#Current Steps:
#1
#505
#6710
#31221+x

while($false){

$molecule1 = @()
for($r = 0;$r -lt $replacements.Length;$r++){
    $in = $replacements[$r][0] #Input to transform
    if($molecule0 -cnotmatch '.?'+$in+'.?'){
        #Write-Host "Input $($in) not in string, skipping";
        continue}
    $out = $replacements[$r][1] #Output of transformation
    $replaceindexes = (Select-String -InputObject $molecule0 -Pattern $in -AllMatches -CaseSensitive).Matches.Index
    $added = 0
    $duplicate = 0
    #Write-Host "Found $($in) $($replaceindexes.Length)times"
    $replaceindexes|%{
        #Write-Host "Index $($_)"
        $testmol = Substitute-substring $_ $in $out $molecule0
        if($testmol -notin $molecule1){
            $molecule1+=$testmol;
            $added++;
        }else{
        $duplicate++
        }
    }
    #Write-Host "Added: $($added)"
}

}