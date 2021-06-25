# (C) 2021 Piotr Biesiada

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$dir=(new-object Net.WebClient).DownloadString("http://www.nbp.pl/kursy/xml/dir.txt")
$dir=$dir -split '[\r\n]'
$list=@()
$dir | foreach {
	if ($_.startswith("c")) {
		$list+=$_
	}
}
write-output "D,K,S"
foreach ($item in $list)
{
	$file=[xml](new-object Net.WebClient).DownloadString("http://www.nbp.pl/kursy/xml/$item.xml")
	$data=$file.tabela_kursow.data_notowania
	$kursk=$file.tabela_kursow.pozycja.kurs_kupna[3] -replace ",","."
	$kurss=$file.tabela_kursow.pozycja.kurs_sprzedazy[3] -replace ",","."
	write-output "$data,$kursk,$kurss"
}
