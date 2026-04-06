$def_path = ".\data\locale"
$def_locale_name = "en-US.ini"
$my_locale_name = "aa-ZZ.ini"
function ReadLocaleAsArray {
    param (
        $fileName
    )
    return Get-Content $fileName | Foreach-Object {
        $x = $_.Split("=")
        return @{Key=$x[0]; Value=$x[1]}
    }
}

function ReadLocale {
    param (
        $fileName
    )
    $r = @{}
    if (!(Test-Path $fileName)) {
        New-Item -Path $fileName -ItemType File | Out-Null
    }
    Get-Content $fileName | Foreach-Object {
        $x = $_.Split("=")
        $r[$x[0]] = $x[1]
    }
    return $r
}

$en_locale = ReadLocaleAsArray ($def_path + "\" + $def_locale_name)

Get-ChildItem $def_path -File | ForEach-Object {
    $cur_locale = ReadLocale ($def_path + "\" + $my_locale_name)
    $en_locale `
    | ForEach-Object {
        if ($cur_locale.ContainsKey($_.Key)) {
            return $_.Key + "=" + $cur_locale[$_.Key]
        } else {
            return $_.Key + "=" + $_.Value
        }
    } `
    | Set-Content -Path ($def_path + "\" + $my_locale_name)
}
