class_name HeroesPaths
extends Object

enum Enum {
	NONE,
	P0, P1, P2, P3,
	G0, G1, G2, G3,
	W0, W1, W2, W3,
	M0, M1, M2, M3,
	H0, H1, H2, H3,
	J0, J1, J2, J3,
	L0, L1, L2, L3,
	O0, O1, O2, O3,
	R0, R1, R2, R3,
	V0, V1, V2, V3,
	F0, F1, F2, F3,
	D0, D1, D2, D3,
	C0, C1, C2, C3,
	A0, A1, A2, A3,
	B0,
}


static func from_text(text: String) -> Enum:
	var names := Enum.keys()
	var index := names.find(text)
	if index == -1:
		return Enum.NONE
	return Enum.values()[index]


static func to_text(hero_path: HeroesPaths.Enum) -> String:
	return HeroesPaths.Enum.keys()[hero_path] as String


static func to_hero(hero_path: HeroesPaths.Enum) -> String:
	return to_text(hero_path).substr(0, 1)


static func is_abomination(hero_path: HeroesPaths.Enum) -> bool:
	return to_hero(hero_path) == "A"
