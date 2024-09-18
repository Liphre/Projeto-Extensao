from PyQt5 import uic, QtWidgets
import mysql.connector
from mysql.connector import Error
from datetime import datetime

# Configuração de conexão com o banco de dados
try:
    banco = mysql.connector.connect(
        host='localhost',
        user='root',
        passwd='',
        database='sistema_escola'
    )
except Error as e:
    print(f"Erro ao conectar com o banco de dados: {e}")


def converter_data(data_str):# FUNCIONALIDADE PARA CONVERTER DATA
    try:
        data = datetime.strptime(data_str, f"%d/%m/%Y")
        data_formatada = data.strftime(f"%Y-%m-%d")
        return data_formatada
    except ValueError:
        print("Formato de data inválido")
        return None
    
def preencherNomes(id):# FUNCIONALIDADE PARA PREENCHER CAMPOS NOMES
    cursor  = banco.cursor()
    c_nomePai = "SELECT nome_P FROM pais_cadastrados where id = %s"
    cursor.execute(c_nomePai, (id,))
    resultado = cursor.fetchone()
    nome_usuario = resultado[0]
    telaUser.nomePai.setText(f"{nome_usuario}")

    c_nomeAluno = ("SELECT A.nome_A FROM alunos A INNER JOIN filhos B ON A.id = B.id_Alunos where B.id_pai = {}".format(id,))
    cursor.execute(c_nomeAluno)
    resultado1 = cursor.fetchone()
    nome_aluno = resultado1[0]
    telaUser.nomeAluno.setText(f"{nome_aluno}")

def pegarIdFilho(idPai):
    try:
        comandoSQL = """ SELECT id_alunos FROM filhos WHERE id_pai = %s;"""
        cursor = banco.cursor()
        cursor.execute(comandoSQL, (idPai,))
        dadosLidos = cursor.fetchone()

        return dadosLidos[0] if dadosLidos else None
    except Error as err:
        print(f"Erro: {err}")
        return None
    finally:
        cursor.close()

def botao_entrar():# telaLogin
    email = telaLogin.lineEdit.text()
    senha = telaLogin.lineEdit_2.text()

    try:
        cursor = banco.cursor()
        cursor.execute("SELECT * FROM pais_cadastrados WHERE email = %s AND senha = %s", (email, senha))
        resultado = cursor.fetchone()
        if resultado:
            global getId 
            userId = resultado[0]
            getId  = userId
            telaLogin.close()
            telaUser.show()
            preencherNomes(userId)
        else:
            QtWidgets.QMessageBox.warning(telaLogin, 'Login', 'Email ou senha incorretos!')
    except Error as e:
        QtWidgets.QMessageBox.critical(telaLogin, 'Erro', f"Erro ao consultar o banco de dados: {e}")

def botao_criarLogin():# telaLogin
    telaLogin.close()
    telaCadastroPais.show()

def botao_registrar():# telaCadastroPais
    nome = telaCadastroPais.lineEdit.text()
    cpf = telaCadastroPais.lineEdit_2.text()
    email = telaCadastroPais.lineEdit_4.text()
    telefone = telaCadastroPais.lineEdit_5.text()
    senha = telaCadastroPais.lineEdit_6.text()
    c_senha = telaCadastroPais.lineEdit_7.text()

    if telaCadastroPais.radioButton.isChecked():
        sexo = "Masculino"
    elif telaCadastroPais.radioButton_2.isChecked():
        sexo = "Feminino"
    else:
        QtWidgets.QMessageBox.information(telaCadastroPais, 'Aviso', 'Sexo não foi selecionado')
        return

    data_nas_str = telaCadastroPais.lineEdit_3.text()
    data_nas = converter_data(data_nas_str)

    if data_nas is None:
        QtWidgets.QMessageBox.warning(telaCadastroPais, 'Aviso', 'Data de nascimento inválida')
        return

    if senha == c_senha:
        try:
            cursor = banco.cursor()
            sql_cadastro = "INSERT INTO pais_cadastrados (nome_P, cpf, data_nascimento, email, telefone, senha, sexo) VALUES (%s, %s, %s, %s, %s, %s, %s)"
            dados = (nome, cpf, data_nas, email, telefone, senha, sexo)
            cursor.execute(sql_cadastro, dados)
            banco.commit()

            QtWidgets.QMessageBox.information(telaCadastroPais, 'Sucesso', 'Cadastro realizado com sucesso, volte à tela de login para efetuar o login.')

            # Limpar campos
            telaCadastroPais.lineEdit.clear()
            telaCadastroPais.lineEdit_2.clear()
            telaCadastroPais.lineEdit_3.clear()
            telaCadastroPais.lineEdit_4.clear()
            telaCadastroPais.lineEdit_5.clear()
            telaCadastroPais.lineEdit_6.clear()
            telaCadastroPais.lineEdit_7.clear()
            telaCadastroPais.radioButton.setChecked(False)
            telaCadastroPais.radioButton_2.setChecked(False)

        except Error as error:
            QtWidgets.QMessageBox.critical(telaCadastroPais, 'Erro', f'Erro ao realizar o cadastro: {error}')
        finally:
            cursor.close()
    else:
        telaCadastroPais.label_8.setText('Senhas inseridas são diferentes')

def botao_voltarLogin():# telaCadastroPais
    telaCadastroPais.close()
    telaLogin.show()

def botao_calendario():# telaCalendario
    telaUser.close()
    telaCalendario.show()
    try:
        global getId
        cursor = banco.cursor()
        comandoSQL = """
        SELECT DATE_FORMAT(C.data_evento, '%d/%m/%Y') AS Data, 
               C.evento AS Evento 
        FROM calendario C
        JOIN calendario_turmas CT ON C.id = CT.id_calendario
        JOIN turmas T ON CT.id_turmas = T.id
        JOIN alunos_turmas A_T ON T.id = A_T.id_turmas
        JOIN alunos A ON A_T.id_alunos = A.id
        WHERE A.id = %s
        ORDER BY Data DESC;
        """
        cursor.execute(comandoSQL, (getId,))
        dadosLidos = cursor.fetchall()
        telaCalendario.tableWidget.setRowCount(len(dadosLidos))
        telaCalendario.tableWidget.setColumnCount(2)
        telaCalendario.tableWidget.setColumnWidth(1, 600)

        for i, row in enumerate(dadosLidos):
            for j, value in enumerate(row):
                telaCalendario.tableWidget.setItem(i, j, QtWidgets.QTableWidgetItem(str(value)))

    except Exception as e:
        print(f"Ocorreu um erro: {e}")

def botao_sairCalendario():# telaCalendario
    telaCalendario.close()
    telaUser.show()

def botao_horarios():# telaHorario
    telaHorarios.show()
    telaUser.close()

    try:
        global getId
        idFilho = pegarIdFilho(getId)
        
        if idFilho is None:
            QtWidgets.QMessageBox.warning(telaUser, 'Aviso', 'Nenhum filho encontrado.')
            return

        cursor = banco.cursor()
        comandoSQL = """
        SELECT
            horario_aula AS 'horario',
            MAX(CASE WHEN H.dia_semana = 'Segunda-Feira' THEN M.nome_M END) AS 'Segunda-Feira',
            MAX(CASE WHEN H.dia_semana = 'Terça-Feira'   THEN M.nome_M END) AS 'Terça-Feira',
            MAX(CASE WHEN H.dia_semana = 'Quarta-Feira'  THEN M.nome_M END) AS 'Quarta-Feira'
        FROM
            horario H
        JOIN 
            materias M       ON H.id_materias = M.id
        JOIN
            turmas T         ON H.id_turmas   = T.id
        JOIN
            alunos_turmas AL ON T.id          = AL.id_turmas
        JOIN
            alunos A         ON AL.id_alunos  = A.id
        WHERE
            A.id = %s
        GROUP BY
            horario_aula
        ORDER BY
            FIELD(horario_aula, '07:15', '08:30', '09:30', '09:45', '10:45');
        """
        cursor.execute(comandoSQL, (idFilho,))
        dadosLidos = cursor.fetchall()

        telaHorarios.tableWidget.setRowCount(len(dadosLidos))
        telaHorarios.tableWidget.setColumnCount(4)

        for i, row in enumerate(dadosLidos):
            for j, value in enumerate(row):
                telaHorarios.tableWidget.setItem(i, j, QtWidgets.QTableWidgetItem(str(value)))

    except Exception as e1:
        print(f"Ocorreu um erro: {e1}")
        telaHorarios.tableWidget.setRowCount(0)
        QtWidgets.QMessageBox.warning(telaHorarios, 'Erro', 'Não foi possível carregar os dados.')
    
    finally:
        if cursor:
            cursor.close()

def botao_sairHoraios():# telaHorario
    telaHorarios.close()
    telaUser.show()

def botao_boletim():# telaBoletim
    telaBoletim.show()
    telaUser.close()

    try:
        global getId
        idFilho = pegarIdFilho(getId)
        
        if idFilho is None:
            QtWidgets.QMessageBox.warning(telaUser, 'Aviso', 'Nenhum filho encontrado.')
            return

        cursor = banco.cursor()
        comandoSQL = """
        SELECT B.periodo_letivo, M.nome_M, B.nota_prova1, B.nota_prova2, B.nota_trabalho, ROUND((B.nota_prova1 + B.nota_prova2 + B.nota_trabalho)/3.0, 2) AS nota_final
        FROM boletim B 
        JOIN materias_turmas MT ON MT.id = B.id_materias_turmas
        JOIN materias M         ON M.id  = MT.id_materias 
        JOIN alunos   A         ON A.id  = B.id_alunos
        WHERE A.id = %s
        ORDER BY B.periodo_letivo;

        """
        cursor.execute(comandoSQL, (idFilho,))
        dadosLidos = cursor.fetchall()

        telaBoletim.tableWidget.setRowCount(len(dadosLidos))
        telaBoletim.tableWidget.setColumnCount(6)

        for i, row in enumerate(dadosLidos):
            for j, value in enumerate(row):
                telaBoletim.tableWidget.setItem(i, j, QtWidgets.QTableWidgetItem(str(value)))

    except Exception as e1:
        print(f"Ocorreu um erro: {e1}")
        telaBoletim.tableWidget.setRowCount(0)
        QtWidgets.QMessageBox.warning(telaBoletim, 'Erro', 'Não foi possível carregar os dados.')
    
    finally:
        if cursor:
            cursor.close()

def botao_sairBoletim():# telaBoletim
    telaBoletim.close()
    telaUser.show()

# Configuração da aplicação PyQt
app = QtWidgets.QApplication([])

# TELAS DA APLICAÇÃO 
telaLogin        = uic.loadUi("tela_login.ui")
telaCadastroPais = uic.loadUi("tela_cadastroPais.ui")
telaUser         = uic.loadUi("tela_user.ui")  
telaCalendario   = uic.loadUi("calendario.ui")
telaHorarios     = uic.loadUi("horarios.ui")
telaBoletim      = uic.loadUi("tela_boletim.ui")

# CONEXÃO DOS BOTÕES
# Tela de login - inicio
telaLogin.pushButton.clicked.connect(botao_entrar)
telaLogin.pushButton_2.clicked.connect(botao_criarLogin)

# Tela de cadastro
telaCadastroPais.pushButton.clicked.connect(botao_registrar)
telaCadastroPais.pushButton_2.clicked.connect(botao_voltarLogin)

# Tela principal do usuário -> telaUser
telaUser.pushButton_2.clicked.connect(botao_calendario)
telaUser.pushButton_3.clicked.connect(botao_horarios)
telaUser.pushButton_4.clicked.connect(botao_boletim)

# Tela calendário
telaCalendario.voltar.clicked.connect(botao_sairCalendario)

# Tela horários
telaHorarios.voltar.clicked.connect(botao_sairHoraios)

# Tela Boletim
telaBoletim.voltar.clicked.connect(botao_sairBoletim)

# Exibindo a tela de login
telaLogin.show()
app.exec()
