#!/usr/bin/python3
import sys
import time
# import unicodedata
import unidecode


def entre(text):
    version = sys.version_info[:1]
    if version == (2,):
        result = input(text)
    elif version == (3,):
        result = input(text)
    else:
        print("Erreur de version")
    return result


def encoder(decalage, s):
    s2 = unidecode.unidecode(s)
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    dico = {}
    inchanges = " .,!?;:/\\&\"'(-_#{[|`^@)]=}$£µ*%§<>²0123456789"
    for lettre in inchanges:
        dico[lettre] = lettre
    position = decalage

    for l in alphabet:
        dico[l] = alphabet[position]
        dico[l.upper()] = alphabet.upper()[position]
        position = (position+1) % len(alphabet)

    # print(dico)

    secret = ""
    for l in s2:
        secret += dico[l]
    print(secret)
    while True:
    try:
        decalage = int(entre("Quel décalage voulez vous ? "))
    except ValueError:
        print("Veiller entrer un nombre valide.")
        continue
    s = entre("Votre mot à coder/décoder : ")

    encoder(decalage, s)
    # print(s)
    # encoder(decalage-decalage*2, s)
