const express = require('express');
const app = express();
const port = 4000;

const bodyParser = require('body-parser');
const pool = require('./db');
const morgan = require('morgan');
const cors = require('cors');
const { json } = require('body-parser');
const { response } = require('express');


 
//middlewares

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true,
}));

app.use(morgan('dev'));
app.use(cors());
app.use(express.json());

//ROUTES//

//USER

// add user
app.post('/user/add', async (req, res) => {
  try {
    const { uid,name } = req.body;
    const newUser = await pool.query(
      "INSERT INTO Users (id_user,name,role) VALUES($1,$2,$3)",
      [uid,name,1],
    );
   res.json(newUser.rows[0]);
   
  } catch (error) {
    console.error(error.message);
  }
});


//check admin
app.get("/user/check/:uid", async (req, res) => {
  try {
    const { uid } = req.params;
    const _user = await pool.query("SELECT * FROM Users WHERE id_user = $1" ,[uid]);
      res.json(_user);
  } catch (error) {
    res.end();
    console.error(error.message);
  }
});
// check user is exist
app.get("/user/check/ex/:uid", async (req, res) => {
  try {
    const { uid } = req.params;
    const _user = await pool.query("SELECT * FROM Users WHERE id_user = $1" ,[uid]);
      res.json(_user);
  } catch (error) {
    res.end();
    console.error(error.message);
  }
});

//get all users
app.get("/user/getall", async (req, res) => {
  try {
    const userData = await pool.query("SELECT * FROM Users");
    res.json(userData.rows);
  } catch (error) {
    res.end();
    console.error(error.message);
  }
});

//get a user
app.get("/user/getone/:id", async (req, res) => {
  try {
    const { uid } = req.params;
    const user = await pool.query("SELECT * FROM Users WHERE id_user = $1",
    [ uid ]
    );

    res.json(user.rows[0]);

  } catch (error) {
    res.end();
    console.error(erro.message);
  }
});
// delete user
app.delete("/user/del/:uid", async (req, res) => {
  try {
    const { uid } = req.params;

    var _checkUrl = await pool.query("SELECT FROM Url WHERE uid = $1",[ uid ]);
    
    if(_checkUrl.rowCount == 0){
      await pool.query("DELETE FROM Users WHERE id_user = $1",[ uid ]);
    }else{
      await pool.query("DELETE FROM Url WHERE uid = $1",[ uid ]);

      await pool.query("DELETE FROM Users WHERE id_user = $1",[ uid ]);
    }
    
    res.json({message:"User was deleted"});

  } catch (error) {
    res.end();
    console.error(error.message);
  }
});

//URL 

//add url & lat & long
app.post('/url/add', async (req, res) => {
  try {
    const { uid,url,lat,long } = req.body;
    const newUrl = await pool.query(
      "INSERT INTO Url (uid,link,lat,long) VALUES($1,$2,$3,$4)",
      [uid,url,lat,long]
    );
   //res.json(newUrl.rows[0]); 
   res.json({message:"Announcement Server"});
  } catch (error) {
    console.error(error.message);
  }
});

// get all url of user
app.get('/url/img/:uid',async (req, res)=> {
try {
  const { uid } = req.params;
  const urlData = await pool.query(
    "SELECT * FROM Url WHERE uid = $1",
    [ uid ]
    );
  
    res.json(urlData);
 
} catch (error) {
  console.error(error.message);
}
});
// update url
app.put('/url/update',async(req, res) =>{
  try {
    const {id,lat,long} = req.body;
    const query = await pool.query(
      "UPDATE Url SET lat = ($1) ,long = ($2) WHERE id_url = ($3)",[lat,long,id]
      );
      let d = new Date() ;
   let date =  d.getDate() + "-" + d.getMonth() + "-" + d.getFullYear()  + " " + d.getHours() + ":" + d.getMinutes();
  res.json({message:"Update sucssecfully",date:date,query:query
});
  } catch (error) {
    res.json({message:"Update fail"});
  }
})
// delete url
app.delete("/url/del/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const user = await pool.query("DELETE FROM Url WHERE id_url = $1",
    [ id ]
    );

    res.json({message:"Image was deleted"});

  } catch (error) {
    res.end();
    console.error(erro.message);
  }
});
// Start the server
const server = app.listen(port, (error) => {
    if (error) return console.log(`Error: ${error}`);
    console.log(`Server listening on port ${server.address().port}`);
});