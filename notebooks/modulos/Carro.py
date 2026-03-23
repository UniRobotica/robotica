class Carro:
    def __init__(self):
        self.cor = "Preto"
        self.quatidade_de_lugares = 7
        self.velocidade_maxima = 200
        self.ligado = False
        self.marcha = 1
        self.velocidade = 0

    def Ligar(self):
        self.ligado = True

    def Acelerar(self):
        self.velocidade += 10

    def Freiar(self):
        self.velocidade -= 10

    def Trocar_Marcha(self, nova_marcha):
        self.marcha = nova_marcha

    def Desligar(self):
        self.ligado = False


class Celta(Carro):
    def __init__(self):
        Carro.__init__(self)
        self.cor = "Prata"
        self.quantidade_de_lugares = 5
        self.ar_condicionado_ligado = False

    def Ligar_ar_condicionado(self):
        self.ar_condicionado_ligado = True

    def Ligar(self):
        self.ligado = True
        self.marcha = 6