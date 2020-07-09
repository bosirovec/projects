import random
ride_id = 1
file = open("gogi.txt","a")

ulice = ['Ulica Ivana Zajca 10, Valpovo',
         'Ulica Ivana Gundulica 4, Valpovo',
         'Ulica Ive Lole Ribara 14, Ladimirevci',
         'Ulica Vladimira Nazora 12, Valpovo',
         'Suncana ulica 44, Valpovo',
         'Ulica Petra Preradovica 2, Valpovo',
         'Ulica Augusta Senoe 5, Valpovo',
         'Ulica Oslobodenja 6, Ivanovci',
         'Ulica Ive Lole Ribara 8, Nard',
         'Ulica Ljudevita Gaja 9, Valpovo',
         'D34, Sag',
         'Naselje Josipa Kozarca 88, Valpovo',
         'Ulica Matije Gupca 55, Valpovo',
         'Ulica Zrinsko Frankopanska 22, Valpovo',
         'Ul. Duke Maricica 8, Ladimirevci',
         'Trg kralja Tomislava 6, Valpovo',
         'Ulica Tina Ujevica 33, Valpovo',
         'Valpovacka ulica 77, Nard',
         'Osjecka ulica 2, Valpovo',
         'Ulica Nikole Tesle 2, Valpovo',
         'Bosanska ulica 98, Valpovo',
         'Mlaka 1,Ladimirevci',
         'Ljudevita Posavskog 4, Belisce',
         'Vijenac Josipa Jurja Strossmayer 5G, Belisce',
         'Antuna Matije Reljkovica 1c, Belisce',
         'Petra Zrinskog 105, Belisce',
         'Antuna Mihanovica 28, Belisce',
         'Eugena Kvaternika 9, Belisce',
         'Matije Gupca 11, Belisce',
         'Ljudevita Gaja 17, Belisce',
         'Antuna Gustava Matosa, Belisce']
phones = ['016266041', '015624865','0915070895','016262926','016636103','016590277','040313579','0977367901','098261414','021256363',
          '018890410','0914825604','0994521771','0916337503','098272667','014840940','0913355506','0995303551','013384950','016701644',
          '032521474','0992838844', '016141780','0800200205']

otd = "'01/07/2019'"
print("Unesi prvu smjenu")
for loop in range(234,252):
    print("unesi id vozila i id telefona")
    v = input()
    for x in range((loop-1)*10+1,(loop-1)*10+16):
        y = random.randint(1,28)
        z = random.randint(1,28)
        p = random.randint(1,20)
        price = random.randint(20,35)
        sql = 'INSERT INTO ride VALUES ({},{},{},{},{},{},{},{},{},{},{});'.format(x,loop,phones[p],random.randint(1,4),price,"'" + ulice[y] + "'", "'" + ulice[z] + "'",otd,1,v,v)
        print (sql)
        file.write("\n")
        file.write(sql)
    
    

    
    
    
    