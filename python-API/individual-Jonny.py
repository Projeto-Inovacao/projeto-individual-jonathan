import psutil
import threading
import time
import keyboard
import socket
import pymssql
import mysql.connector
import json
import requests
from datetime import datetime
from cred import usr, pswd

event = threading.Event()
print(event)

def stop():
    event.set()
    print("\nFinalizando monitoramento")
    print(event)

keyboard.add_hotkey("esc", stop)

while not event.is_set():
    
    memoria = psutil.virtual_memory()
    hostname = socket.gethostname()

    # Memória
    memoria_disponivel = memoria.available
    memoria_total = memoria.total

    mydb = mysql.connector.connect(host='localhost', user=usr, password=pswd, database='nocline')
    
    try:
        if mydb.is_connected():
            db_info = mydb.get_server_info()
                
            mycursor = mydb.cursor()
        
            sql_query = "SELECT id_maquina, fk_empresaM FROM maquina WHERE hostname = %s;"
            mycursor.execute(sql_query, (hostname,))
            
            result = mycursor.fetchone()
            
            if result:
                id_maquina, fk_empresaM = result
                
                sql_query = """
                INSERT INTO monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida)
                VALUES (%s, now(), 'memoria disponivel', (SELECT id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                       (%s, now(), 'memoria total', (SELECT id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s));
                """
                val = [cpu_percentual, data_hora_local, id_maquina, id_maquina, fk_empresaM, '%',
                    memoria_disponivel, id_maquina, id_maquina, fk_empresaM, 'B',
                       memoria_total, id_maquina, id_maquina, fk_empresaM, 'B']
                
                mycursor.execute(sql_query, val)
                mydb.commit()
                print(mycursor.rowcount, "registros inseridos no banco")
                print("\r\n")
            else:
                print("A máquina " + hostname + " não foi cadastrada no site. Cadastre-a para fazer a captura!")
    
    except mysql.connector.Error as e:
        print("Erro ao conectar com o MySQL:", e)
    
    finally:
        if mydb.is_connected():
            mycursor.close()
            mydb.close()

            # Conexão com o servidor remoto
            try:
                mydb_server = pymssql.connect(server='52.22.58.174', database='nocline', user='sa', password='urubu100')

                try:
                    mycursor_server = mydb_server.cursor()
                    sql_query_server = "SELECT TOP 1 id_maquina, fk_empresaM FROM maquina WHERE hostname = %s;"
                    mycursor_server.execute(sql_query_server, (hostname,))
                    result = mycursor_server.fetchone()

                    if result:
                        id_maquina, fk_empresaM = result
                        data_hora_local = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                        sql_query = """
                                INSERT INTO monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida)
                                VALUES (%s, %s, 'uso de cpu py', (SELECT TOP 1 id_componente from componente WHERE nome_componente = 'CPU' and fk_maquina_componente = %s), %s, %s, (SELECT TOP 1 id_unidade FROM unidade_medida WHERE representacao = %s)),
                                    (%s, %s, 'memoria disponivel', (SELECT TOP 1 id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT TOP 1 id_unidade FROM unidade_medida WHERE representacao = %s)),
                                    (%s, %s, 'memoria total', (SELECT TOP 1 id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT TOP 1 id_unidade FROM unidade_medida WHERE representacao = %s));
                            """
                        val = (cpu_percentual, data_hora_local, id_maquina, id_maquina, fk_empresaM, '%',
                                memoria_disponivel, data_hora_local, id_maquina, id_maquina, fk_empresaM, 'B',
                                memoria_total, data_hora_local, id_maquina, id_maquina, fk_empresaM, 'B')
                        mycursor_server.execute(sql_query, val)
                        mydb_server.commit()
                        print(mycursor_server.rowcount, "registros inseridos no servidor remoto")
                        print("\r\n")

                except mysql.connector.Error as e:
                    print("Erro ao conectar com o servidor MySQLServer:", e)

                finally:
                        mycursor_server.close()
                        mydb_server.close()

            except pymssql.OperationalError as e:
                print("Houve um erro ao realizar o insert.")
                print(f"Detalhes: {e}")

            try:
                sql_query = """
                    INSERT INTO monitoramento (dado_coletado, data_hora, descricao, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida)
                    VALUES (%s, now(), 'uso de cpu py', (SELECT id_componente from componente WHERE nome_componente = 'CPU' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                                                      (%s, now(), 'memoria disponivel', (SELECT id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s)),
                           (%s, now(), 'memoria total', (SELECT id_componente from componente WHERE nome_componente = 'RAM' and fk_maquina_componente = %s), %s, %s, (SELECT id_unidade FROM unidade_medida WHERE representacao = %s));
                """
                val = [cpu_percentual, id_maquina, id_maquina, fk_empresaM, '%',
                       memoria_disponivel, id_maquina, id_maquina, fk_empresaM, 'B',
                       memoria_total, id_maquina, id_maquina, fk_empresaM, 'B']
                

                mycursor.execute(sql_query, val)
                mydb.commit()
                print(mycursor.rowcount, "registros inseridos no banco")
                print("\r\n")

            except mysql.connector.Error as e:
                print("Erro ao conectar com o MySQL:", e)

            finally:
                if mydb and mydb.is_connected():
                    mycursor.close()
                else:
                    print(f"A máquina {hostname} não foi cadastrada.")

    
        
        time.sleep(30)
