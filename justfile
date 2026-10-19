default:
	just --choose

list-todos:
	rg -g '!justfile' 'TODO'

build-agh:
	ankigen build "Space Technologies Master's Degree" -o agh.apkg

edit-agh:
	ranger "Space Technologies Master's Degree/Semester 0"
