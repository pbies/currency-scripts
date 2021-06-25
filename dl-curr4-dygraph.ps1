# (C) 2021 Piotr Biesiada

$file="wal.csv"
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$dir=(new-object Net.WebClient).DownloadString("http://www.nbp.pl/kursy/xml/dir.txt")
$dir=$dir -split '[\r\n]'
$list=@()
$dir | foreach {
	if ($_.startswith("a")) {
		$list+=$_
	}
}
write-output "D,GBP,EUR,CHF,USD,NOK" | out-file -encoding utf8 $file
foreach ($item in $list)
{
	$xml=[xml](new-object Net.WebClient).DownloadString("http://www.nbp.pl/kursy/xml/$item.xml")
	$data=$xml.tabela_kursow.data_publikacji

	$kursgbp=$xml.SelectNodes("//tabela_kursow/pozycja/kod_waluty[text()='GBP']/../kurs_sredni").innertext -replace ",","."
	$kurseur=$xml.SelectNodes("//tabela_kursow/pozycja/kod_waluty[text()='EUR']/../kurs_sredni").innertext -replace ",","."
	$kurschf=$xml.SelectNodes("//tabela_kursow/pozycja/kod_waluty[text()='CHF']/../kurs_sredni").innertext -replace ",","."
	$kursusd=$xml.SelectNodes("//tabela_kursow/pozycja/kod_waluty[text()='USD']/../kurs_sredni").innertext -replace ",","."
	$kursnok=$xml.SelectNodes("//tabela_kursow/pozycja/kod_waluty[text()='NOK']/../kurs_sredni").innertext -replace ",","."
	write-output "$data,$kursgbp,$kurseur,$kurschf,$kursusd,$kursnok" | out-file -append -encoding utf8 $file
}
