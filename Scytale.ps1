function Handle-Input {
    param (
        [string]$inputChoice
    )
    Switch($inputChoice) {
        "e" {
            $plainText = Read-Host 'Input text to be encrypted'
            $key = Read-Host 'Input encryption key'
            write-host "Result:"
            Scytale-Encrypt $plainText $key
        }
        "d" {
            $cipherText = Read-Host 'Input text to be decrypted'
            $key = Read-Host 'Input decryption key'
            write-host "Result:"
            Scytale-Decrypt $cipherText $key
        }
        default {
            $inputChoice = Read-Host 'Invalid input. Input "e" for encryption or "d" for decryption'
            Handle-Input $inputChoice
        }
    }
}

function Scytale-Encrypt {
    param (
        [string]$plainText,
        [int]$key
    )
    $cipherText = ""

    foreach($j in 0..$key) {
        foreach($i in 0..$plainText.length) {
            if($i % $key -eq $j) {
                $cipherText += $plainText[$i]
            }
        }
    }
    $cipherText = Insert-Spaces $cipherText $spacesPos
    write-host $cipherText
}

function Scytale-Decrypt {
    param (
        [string]$cipherText,
        [int]$key
    )
    $plainText = ""

    $rows = $cipherText.length/$key
    $rows = [int][Math]::Ceiling($rows)
    $cipherText = Fill-Empty-Space $cipherText $key $rows

    for($j = 0; $j -lt $rows; $j++) {
        for($i = 0; $i -lt $key; $i++) {
            if(($j * $key) + $i -lt ($cipherText.length)) {
                $plainText += $cipherText[$i * $rows + $j]
            }
        }
    }
    write-host $plainText
}

function Fill-Empty-Space {
    param (
        [string]$text,
        [int]$key,
        [int]$rows
    )
    $totalSpots = $key * $rows
    $emptySpots = $totalSpots - $text.length

    if($emptySpots -eq 0) {
        return $text
    }
    
    $columnsToEmptySpot = ($key - $emptySpots) + 1
    $startIndex = ($rows * $columnsToEmptySpot) - 1

    for($j = $startIndex; $j -le $totalSpots; $j += $rows) {
        $text = $text.insert($j, " ")
    }
    return $text
}

function Reterieve-Spaces-Pos {
    param (
        [string]$text
    )
    $spacesPos = @()
    $i = 0
    foreach($char in [char[]]$text) {
        if($char -eq " ") {
            $spacesPos += $i
        }
        $i++
    }
    return $spacesPos
}

function Insert-Spaces {
    param (
        [string]$text,
        [int[]]$spacesPos
    )
    foreach($spacePos in $spacesPos) {
        $text = $text.insert($spacePos, " ")
    }
    return $text
}

$inputChoice = Read-Host 'Input "e" for encryption or "d" for decryption'
Handle-Input $inputChoice

write-host "Test cases:"
Scytale-Decrypt "PSOHWEELRL" 5
Scytale-Encrypt "Th1s_is a t3st!" 3