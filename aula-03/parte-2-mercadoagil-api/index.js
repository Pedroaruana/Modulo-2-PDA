import express from 'express'

// Cria o servidor: a "cozinha" do MercadoÁgil
const app = express()

// Os dados ficam na memória por enquanto (o banco entra nas próximas aulas)
const produtos = [
  { id: 1, nome: 'Mouse', preco: 120 },
  { id: 2, nome: 'Teclado', preco: 350 },
  { id: 3, nome: 'Livro de JavaScript', preco: 80 },
]

const vendedores = [
  { id: 1, nomeLoja: 'TechBahia' },
  { id: 2, nomeLoja: 'Livraria Sol' },
]

// Rota: quando chegar um GET em "/", responde com um texto
app.get('/', (req, res) => {
  res.send('Olá! Esta é a API do MercadoÁgil.')
})

// Rota: quando chegar um GET em "/produtos", responde com a lista em JSON
app.get('/produtos', (req, res) => {
  res.json(produtos)
})

app.get('/vendedores', (req, res) => {
  res.json(vendedores)
})

// Liga o servidor na porta 3000. Se a porta estiver ocupada, o "erro" conta o motivo
app.listen(3000, (erro) => {
  if (erro) {
    console.log('Não consegui ligar o servidor:', erro.message)
  } else {
    console.log('Servidor do MercadoÁgil rodando em http://localhost:3000')
  }
})
