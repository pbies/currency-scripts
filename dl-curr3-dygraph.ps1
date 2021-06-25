# (C) 2021 Piotr Biesiada

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$dir=(new-object Net.WebClient).DownloadString("http://www.nbp.pl/kursy/xml/dir.txt")
$dir=$dir -split '[\r\n]'
$list=@()
$dir | foreach {
	if ($_.startswith("a")) {
		$list+=$_
	}
}
write-output "D,EUR,USD,CHF,GBP"
foreach ($item in $list)
{
	$file=[xml](new-object Net.WebClient).DownloadString("http://www.nbp.pl/kursy/xml/$item.xml")
	$data=$file.tabela_kursow.data_publikacji
	$kurseur=$file.tabela_kursow.pozycja.kurs_sredni[7] -replace ",","."
	$kursusd=$file.tabela_kursow.pozycja.kurs_sredni[1] -replace ",","."
	$kurschf=$file.tabela_kursow.pozycja.kurs_sredni[9] -replace ",","."
	$kursgbp=$file.tabela_kursow.pozycja.kurs_sredni[10] -replace ",","."
	write-output "$data,$kurseur,$kursusd,$kurschf,$kursgbp"
}
