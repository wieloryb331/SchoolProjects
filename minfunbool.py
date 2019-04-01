def minimalizacja(ind, krok):
    # Created by Dominik Szymkowiak

    def wypisz_tab(tabelka):
        for w in tabelka:
            print(w)

    # Konwertowanie wejscia na liczbe binarna o dlugosci 8
    indeks = ind

    indeks_bin = "{0:b}".format(indeks)  # w tej zmiennej znajduje sie gotowa liczba binarna
    if len(indeks_bin) < 8:
        dl = len(indeks_bin)
        il_zer = 8 - dl
        for nu in range(il_zer):
            indeks_bin = '0' + indeks_bin
    #

    # Tworzenie tabelki
    # tableka funkcji ma zawsze 4 kolumny i 8 wierszy
    il_wierszy = 8
    il_kolumn = 4
    # tworzenie macierzy o 4 kolumnach i 8 wierszach wypelnionej zerami
    tabelka1 = [[0 for y in range(il_kolumn)] for x in range(il_wierszy)]
    #

    # Wypelnianie tabelki 1-kami dla kolumn x,y,z
    # Wypelnianie dla kolumny 'x'
    licz = 4
    for wiersz in tabelka1:
        if licz > 0:
            wiersz[0] = 1
            licz = licz - 1

    # Wypelnianie dla kolumny 'y'
    tabelka1[0][1] = 1
    tabelka1[1][1] = 1
    tabelka1[4][1] = 1
    tabelka1[5][1] = 1

    # Wypelnienie dla kolumny 'z'
    tabelka1[0][2] = 1
    tabelka1[2][2] = 1
    tabelka1[4][2] = 1
    tabelka1[6][2] = 1
    #

    # Wypelnianie dla kolumny 'f' wartosciami na podstawie liczby binarnej
    for i in range(il_wierszy):
        tabelka1[i][3] = int(indeks_bin[i])

    if krok == '1':
        print("\nTablica Karnaugha wyjsciowa:\n")
        print("[x, y, z, f]")
        wypisz_tab(tabelka1)
        print("\n#######\n")

    # Tworzenie tej drugiej tabelki
    il_wierszy2 = 2
    il_kolumn2 = 4
    tabelka2 = [[0 for y in range(il_kolumn2)] for x in range(il_wierszy2)]
    #

    # Uzupelnianie drugiej tabelki
    if tabelka1[0][3] == 1:
        tabelka2[0][0] = 1

    if tabelka1[1][3] == 1:
        tabelka2[0][1] = 1

    if tabelka1[2][3] == 1:
        tabelka2[1][0] = 1

    if tabelka1[3][3] == 1:
        tabelka2[1][1] = 1

    if tabelka1[4][3] == 1:
        tabelka2[0][3] = 1

    if tabelka1[5][3] == 1:
        tabelka2[0][2] = 1

    if tabelka1[6][3] == 1:
        tabelka2[1][3] = 1

    if tabelka1[7][3] == 1:
        tabelka2[1][2] = 1
    #
    if krok == '1':
        print("Tablica Karnaugha przeksztalcona: \n")
        print("    [x, x,~x,~x]")
        print("[ y]", end='')
        print(tabelka2[0])
        print("[~y]", end='')
        print(tabelka2[1])
        print("    [z,~z,~z, z]")
        print("\n#######\n")

    # Dwuwymiarowa lista cykliczna, ktorej bede uzywac zamiast tabelki drugiej
    # Instancja tej klasy odpowiada za jedno pole tabelki

    class Pole:
        def __init__(self, wartosc, pozycja, lewo=None, prawo=None, dol=None, gora=None):
            self.wartosc = wartosc
            self.pozycja = pozycja
            self.lewo = lewo
            self.prawo = prawo
            self.gora = gora
            self.dol = dol

        def __str__(self):
            return p.wartosc

    # Tworzenie pól
    zerozero = Pole(tabelka2[0][0], '00')
    zerojeden = Pole(tabelka2[0][1], '01')
    zerodwa = Pole(tabelka2[0][2], '02')
    zerotrzy = Pole(tabelka2[0][3], '03')

    jedenzero = Pole(tabelka2[1][0], '10')
    jedenjeden = Pole(tabelka2[1][1], '11')
    jedendwa = Pole(tabelka2[1][2], '12')
    jedentrzy = Pole(tabelka2[1][3], '13')

    ###

    # Nadawanie relacji między polami
    zerozero.lewo = zerotrzy
    zerozero.prawo = zerojeden
    zerozero.gora = jedenzero
    zerozero.dol = jedenzero

    zerojeden.lewo = zerozero
    zerojeden.prawo = zerodwa
    zerojeden.gora = jedenjeden
    zerojeden.dol = jedenjeden

    zerodwa.lewo = zerojeden
    zerodwa.prawo = zerotrzy
    zerodwa.gora = jedendwa
    zerodwa.dol = jedendwa

    zerotrzy.lewo = zerodwa
    zerotrzy.prawo = zerozero
    zerotrzy.gora = jedentrzy
    zerotrzy.dol = jedentrzy
    #
    jedenzero.lewo = jedentrzy
    jedenzero.prawo = jedenjeden
    jedenzero.gora = zerozero
    jedenzero.dol = zerozero

    jedenjeden.lewo = jedenzero
    jedenjeden.prawo = jedendwa
    jedenjeden.gora = zerojeden
    jedenjeden.dol = zerojeden

    jedendwa.lewo = jedenjeden
    jedendwa.prawo = jedentrzy
    jedendwa.gora = zerodwa
    jedendwa.dol = zerodwa

    jedentrzy.lewo = jedendwa
    jedentrzy.prawo = jedenzero
    jedentrzy.gora = zerotrzy
    jedentrzy.dol = zerotrzy

    # Znajdywanie sasiadujacych ze soba współrzędnych(pary)
    lista_pola = [zerozero, zerojeden, zerodwa, zerotrzy, jedenzero, jedenjeden, jedendwa, jedentrzy]
    lista_all = [p.pozycja for p in lista_pola if
                 p.wartosc == 1]  # w tej liscie sa wszystkie wspolrzedne gdzie jest jedynka
    lista_pary = []
    i = 0
    for p in lista_pola:
        if p.wartosc == 1:
            if p.prawo.wartosc == 1:
                lista_pary.append([p.pozycja, p.prawo.pozycja])
            if p.lewo.wartosc == 1:
                lista_pary.append([p.lewo.pozycja, p.pozycja])
            if i < len(lista_pola) / 2:
                if p.dol.wartosc == 1:
                    lista_pary.append([p.pozycja, p.dol.pozycja])
        i = i + 1

    # Usuwanie duplikatow z listy
    c_lista_pary = []  # w tej liscie sa wszystkie pary bez powtorzen
    [c_lista_pary.append(x) for x in lista_pary if x not in c_lista_pary]

    # Znajdowanie sasiadujacych ze soba czwórek współrzędnch
    # kwadrat
    lista_czworki = []
    i = 0
    p = 0
    for nu in range(len(lista_pola)):
        if i == 4:
            break
        if lista_pola[p].wartosc == 1:
            if lista_pola[p].prawo.wartosc == 1 and lista_pola[p].prawo.dol.wartosc == 1 and lista_pola[
                p].dol.wartosc == 1:
                lista_czworki.append([lista_pola[p].pozycja, lista_pola[p].prawo.pozycja, lista_pola[p].dol.pozycja,
                                      lista_pola[p].prawo.dol.pozycja])
        i = i + 1
        p = p + 1
        if p > 3:
            break

    # prostokąt
    if lista_pola[0].wartosc == 1:
        if lista_pola[1].wartosc == 1 and lista_pola[2].wartosc == 1 and lista_pola[3].wartosc == 1:
            lista_czworki.append(
                [lista_pola[0].pozycja, lista_pola[1].pozycja, lista_pola[2].pozycja, lista_pola[3].pozycja])
    if lista_pola[4].wartosc == 1:
        if lista_pola[5].wartosc == 1 and lista_pola[6].wartosc == 1 and lista_pola[7].wartosc == 1:
            lista_czworki.append(
                [lista_pola[4].pozycja, lista_pola[5].pozycja, lista_pola[6].pozycja, lista_pola[7].pozycja])
    if krok == '1':
        print("Wszystkie istniejace pary wspolrzednych dla tego zestawu danych w przeksztalconej tabelce to: ")
        if len(c_lista_pary) == 0:
            print("Brak", end='')
        else:
            for x in c_lista_pary:
                print("({}, {}) ".format(x[0], x[1]), end='')
        print("\n")
        print("Wszystkie istniejace czworki wspolrzednych dla tego zestawu danych w przekształconej tabelce to: ")
        if len(lista_czworki) == 0:
            print("Brak", end='')
        else:
            for x in lista_czworki:
                print("({}, {}, {}, {}) ".format(x[0], x[1], x[2], x[3]), end='')
        print("\n\nWspolrzedne nie bedace w zadnej parze badz czworce: ")

    lista_bezpary = []  # w tej liscie sa wszystkie wspolrzedne bez pary
    for x in lista_all:
        lista_bezpary.append(x)

    for x in c_lista_pary:
        for y in lista_all:
            if y in x:
                if y in lista_bezpary:
                    lista_bezpary.remove(y)

    if krok == '1':
        if len(lista_bezpary) == 0:
            print("Brak", end='')
        else:
            print(*lista_bezpary, end=' ')
        print("\n\n#######\n")

    # Tworzenie ostatecznej listy par, które nie występują w środku żadnej czworki
    # Trzeba mieć na uwadze, że czwórki sa zawsze ważniejsze od par
    lista_pary_ostat = [x for x in c_lista_pary]
    for x in lista_czworki:
        for y in c_lista_pary:
            if y[0] in x and y[1] in x:
                if y in lista_pary_ostat:
                    lista_pary_ostat.remove(y)

    if krok == '1':
        print("Pary wspolrzednych dla tego zestawu danych w przeksztalconej tabelce po zredukowaniu liczby par to: ")
        if len(lista_pary_ostat) == 0:
            print("Brak", end='')
        else:
            for x in lista_pary_ostat:
                print("({}, {}) ".format(x[0], x[1]), end='')
        print("\n\n#######\n")

    dict_translate = {
        '00': ['x', 'y', 'z'],
        '01': ['x', 'y', '-z'],
        '02': ['-x', 'y', '-z'],
        '03': ['-x', 'y', 'z'],
        '10': ['x', '-y', 'z'],
        '11': ['x', '-y', '-z'],
        '12': ['-x', '-y', '-z'],
        '13': ['-x', '-y', 'z']
    }

    trans_lista_alone = []
    trans_lista_pary = []
    trans_lista_czworki = []
    # Zamiana współrzędnych na argumenty funkcji(x,y,z,-x,-y,-z)
    for x in lista_bezpary:
        trans_lista_alone.append(dict_translate[x])

    i = 0
    for x in lista_pary_ostat:
        trans_lista_pary.append([])
        for y in x:
            for z in dict_translate[y]:
                trans_lista_pary[i].append(z)
        i = i + 1

    i = 0
    for x in lista_czworki:
        trans_lista_czworki.append([])
        for y in x:
            for z in dict_translate[y]:
                trans_lista_czworki[i].append(z)

        i = i + 1

    lista_skladnikow_2 = []
    lista_skladnikow_4 = []
    lista_skladnikow_ostateczna = []

    for itr in trans_lista_pary:
        if 'x' in itr and '-x' in itr:
            itr.remove('x')
            itr.remove('-x')
        if 'y' in itr and '-y' in itr:
            itr.remove('y')
            itr.remove('-y')
        if 'z' in itr and '-z' in itr:
            itr.remove('z')
            itr.remove('-z')
        lista_skladnikow_2.append(itr)

    for x in lista_skladnikow_2:
        for y in x:
            if x.count(y) == 2:
                x.remove(y)

    for itr in trans_lista_czworki:
        if 'x' in itr and '-x' in itr and itr.count('x') == 2 and itr.count('-x') == 2:
            itr.remove('x')
            itr.remove('x')
            itr.remove('-x')
            itr.remove('-x')
        if 'y' in itr and '-y' in itr and itr.count('y') == 2 and itr.count('-y') == 2:
            itr.remove('y')
            itr.remove('y')
            itr.remove('-y')
            itr.remove('-y')
        if 'z' in itr and '-z' in itr and itr.count('z') == 2 and itr.count('-z') == 2:
            itr.remove('z')
            itr.remove('z')
            itr.remove('-z')
            itr.remove('-z')
        lista_skladnikow_4.append(itr)

    for x in lista_skladnikow_4:
        for y in x:
            if x.count(y) == 4:
                x.remove(y)
                x.remove(y)
                x.remove(y)

    for x in trans_lista_alone:
        lista_skladnikow_ostateczna.append(x)

    for x in lista_skladnikow_2:
        lista_skladnikow_ostateczna.append(x)

    for x in lista_skladnikow_4:
        lista_skladnikow_ostateczna.append(x)

    lista_do_returna = []
    for x in lista_skladnikow_ostateczna:
        if len(x) > 1:
            r = '∧'
            r = r.join(x)
            lista_do_returna.append(r)
        else:
            lista_do_returna.append(x[0])

    for i in range(len(lista_do_returna)):
        if len(lista_do_returna[i]) > 2:
            lista_do_returna[i] = '(' + lista_do_returna[i] + ')'

    ret = '∨'
    print('Postac minimalna trojargumentowej funkcji boolowskiej o indeksie {} to: '.format(indeks), end='')
    if len(lista_do_returna) == 0:
        print('0')
    elif len(lista_czworki) == 6:
        print('1')
    else:
        print(ret.join(lista_do_returna))


if __name__ == '__main__':
    print("Witaj w programie do minimalizowania trojargumentowych funkcji boolowskich stworzonym przez Dominika Szymkowiaka")

    while 1:
        print("\nWybierz jedna sposrod dostepnych opcji: ")
        print("1. Oblicz postac minimalna funkcji o danym indeksie (tylko wynik)")
        print("2. Oblicz postac minimalna funkcji o danym indeksie (krok po kroku)")
        print("3. Wypisz wszystkie postaci minimalne trojargumentowych funckji boolowskich")
        print("4. Wyjdz z programu\n")
        print("Aby wybrac 1. wpisz '1' \n")
        wybor = int(input("Wybieram: "))
        if wybor == 1:
            while 1:
                arg = int(input("Wprowadź indeks funkcji trojargumentowej: "))
                if arg == -1:
                    break
                elif arg < 256:
                    minimalizacja(arg, '0')
                else:
                    print("Zla liczba! Indeksy tylko z przedzialu [0,255]")
                print("\nAby przejsc do menu wpisz '-1', aby kontuowac podaj kolejny indeks")
        elif wybor == 2:
            while 1:
                arg = int(input("Wprowadź indeks funkcji trojargumentowej: "))
                if arg == -1:
                    break
                elif arg < 256:
                    minimalizacja(arg, '1')
                else:
                    print("Zla liczba! Indeksy tylko z przedzialu [0,255]")
                print("\nAby przejsc do menu wpisz '-1', aby kontuowac podaj kolejny indeks")
        elif wybor == 3:
            for i in range(0, 256):
                minimalizacja(i, '0')
                print("######\n")
        elif wybor == 4:
            print("See you soon")
            break
        else:
            print("Zła wartosc, podaj liczbe z przedzialu [1,3]")

