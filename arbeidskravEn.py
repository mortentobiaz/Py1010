"""
ArbeidskavEn, opprettet av Morten Tobiassen
Oppretet 25.09.25
mto@nhh.no

"""

# initielle statiske variabler

K = 10000 # angir antall km kjørelengde bilen har i året
FE = 5000 # angir forsikring for El bil i året
FB = 7500 # angir forsikring for Bensin bil i året 
TF = 8.38 * 365 # angir trafikkforsikring pr år 
DE = 0.2 * 2 # pris i kroner pr km for elbil
DB = 1 # pris pr km for bensinbil
BE = 0.1 # bompenger for elbil pr km
BB = 0.3 # bompenmger for bensinbil pr km

# beregnings variabler

KostELbil = (FE + TF) + (DE * K) + (BE * K) # årlig kost EL bil
kostBensinbil = (FB + TF) + (DB * K) + (BB * K) # årlig kost for bensin bil
kostDiff = kostBensinbil-KostELbil # kost differanse mellom bensin og EL bil

print("Kostnad for å kjøre en el bil med", K, "km kjørelengde",KostELbil,"Nok")
print("Kostnad for å kjøre en bensin bil med", K ," km kjørelengde", kostBensinbil ,"Nok")
print("Differansen i kostnad mellom bensin bil og EL bil for", K, "kjørte km i året er", kostDiff,"Nok")


