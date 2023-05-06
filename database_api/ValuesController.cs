using System;
using System.Web.Http;
using System.Data;
using Newtonsoft.Json;
using System.Security.Claims;
using System.Data.SqlClient;
using WebApiDemo.Models;

public class ValuesController : ApiControllerBase
{
   [Route("api/getAccountLogin")]
   public IHttpActionResult GetAccountToLogin()
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"SELECT * from users";
         DataTable tableNhanVien = Command.GetDataTable();

         var respone = new ResultModel
         {
            Data = JsonConvert.SerializeObject(tableNhanVien)

         };
         return Ok(respone);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }

   }


   [Route("api/getAccount/{userID}")]
   public IHttpActionResult GetAccount(int userID)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"SELECT * from users where users.UserID = @userID";

         Command.Parameters.AddWithValue("@userID", userID);
         DataTable tableNhanVien = Command.GetDataTable();

         var respone = new ResultModel
         {
            Data = JsonConvert.SerializeObject(tableNhanVien)

         };
         return Ok(respone);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }

   }

   [HttpPut]
   [Route("api/updateUser/{userID}")]
   public IHttpActionResult UpdateUserWithUserID(int userID, [FromBody] UserModel user)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"UPDATE users SET Username = @Username, Fullname=@Fullname, Password=@Password, Email=@Email WHERE UserID = @UserID";
         Command.Parameters.AddWithValue("@Username", user.Username);
         Command.Parameters.AddWithValue("@Fullname", user.Fullname);
         Command.Parameters.AddWithValue("@Password", user.Password);
         Command.Parameters.AddWithValue("@Email", user.Email);

         Command.Parameters.AddWithValue("@UserID", user.UserID);

         Command.ExecuteNonQuery();
         var response = new ResultModel { };
         return Ok(response);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }
   }

   [HttpPost]
   [Route("api/addUser")]
   public IHttpActionResult AddUser([FromBody] UserModel user)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"INSERT INTO users (Username, Fullname, Password, Email)
                                 VALUES (@Username, @Fullname, @Password, @Email)";
         Command.Parameters.AddWithValue("@Username", user.Username);
         Command.Parameters.AddWithValue("@Fullname", user.Fullname);
         Command.Parameters.AddWithValue("@Password", user.Password);
         Command.Parameters.AddWithValue("@Email", user.Email);

         Command.ExecuteNonQuery();
         var response = new ResultModel { };
         return Ok(response);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }
   }



   [HttpPost]
   [Route("api/addBoard")]
   public IHttpActionResult AddBoard([FromBody] BoardModel board)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"INSERT INTO boards (BoardName, CreatedDate, UserID, Labels, LabelsColor)
                                 VALUES (@BoardName, @CreatedDate, @UserID, @Labels, @LabelsColor)";
         Command.Parameters.AddWithValue("@BoardName", board.BoardName);
         Command.Parameters.AddWithValue("@CreatedDate", board.CreatedDate);
         Command.Parameters.AddWithValue("@UserID", board.UserID);
         Command.Parameters.AddWithValue("@Labels", board.Labels);
         Command.Parameters.AddWithValue("@LabelsColor", board.LabelsColor);
         Command.ExecuteNonQuery();
         var response = new ResultModel { };
         return Ok(response);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }
   }

   [HttpPost]
   [Route("api/addChecklistitem")]
   public IHttpActionResult AddChecklistItem([FromBody] CheckListItemModel checklistitems)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"INSERT INTO checklistitems (ChecklistID, Title)
                                 VALUES (@ChecklistID, @Title)";
         Command.Parameters.AddWithValue("@ChecklistID", checklistitems.ChecklistID);
         Command.Parameters.AddWithValue("@Title", checklistitems.Title);
         Command.ExecuteNonQuery();
         var response = new ResultModel { };
         return Ok(response);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }
   }

   [HttpPost]
   [Route("api/addCard")]
   public IHttpActionResult AddCard([FromBody] CardModel card)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"INSERT INTO boards (ListID, CreatorID, CardName, Label, Comment, CreatedDate, DueDate, LabelColor)
                                 VALUES (@ListID, @CreatorID, @CardName, @Label, @Comment, @CreatedDate, @DueDate, @LabelColor)";
         Command.Parameters.AddWithValue("@ListID", card.ListID);
         Command.Parameters.AddWithValue("@CreatorID", card.CreatorID);
         Command.Parameters.AddWithValue("@CardName", card.CardName);
         Command.Parameters.AddWithValue("@Label", card.Label);
         Command.Parameters.AddWithValue("@Comment", card.Comment);
         Command.Parameters.AddWithValue("@CreatedDate", card.CreatedDate);
         Command.Parameters.AddWithValue("@DueDate", card.DueDate);
         Command.Parameters.AddWithValue("@LabelColor", card.LabelColor);
         Command.ExecuteNonQuery();
         var response = new ResultModel { };
         return Ok(response);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }
   }


   [HttpPut]
   [Route("api/updateCard/{cardID}")]
   public IHttpActionResult UpdateCard(int cardID, [FromBody] CardModel card)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"UPDATE cards SET DueDate = @DueDate WHERE CardID = @CardID";
         Command.Parameters.AddWithValue("@DueDate", card.DueDate);
         Command.Parameters.AddWithValue("@CardID", card.CardID);
         Command.ExecuteNonQuery();
         var response = new ResultModel { };
         return Ok(response);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }
   }



   [HttpDelete]
   [Route("api/deleteBoard/{boardId}")]
   public IHttpActionResult DeleteBoard(int boardId)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"DELETE FROM boards WHERE BoardID = @BoardID";
         Command.Parameters.AddWithValue("@BoardID", boardId);
         Command.ExecuteNonQuery();
         var response = new ResultModel { };
         return Ok(response);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }
   }

   [HttpDelete]
   [Route("api/deleteChecklistitem/{Title}")]
   public IHttpActionResult DeleteChecklistitem(string Title)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"DELETE FROM checklistitems WHERE Title = @Title";
         Command.Parameters.AddWithValue("@Title", Title);
         Command.ExecuteNonQuery();
         var response = new ResultModel { };
         return Ok(response);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }
   }


   // GET api/values
   //[Authorize]
   [Route("api/getboards")]
   public IHttpActionResult GetBoards()
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"select * from boards";
         DataTable tableNhanVien = Command.GetDataTable();

         var respone = new ResultModel
         {
            Data = JsonConvert.SerializeObject(tableNhanVien)

         };
         return Ok(respone);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }

   }
   // GET api/values
   //[Authorize]
   [Route("api/getcards")]
   public IHttpActionResult GetCards()
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"SELECT cards.*, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards
LEFT JOIN checklists ON cards.cardID = checklists.cardID
LEFT JOIN checklistitems ON checklists.checklistID = checklistitems.checklistID
GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor;";
         DataTable tableNhanVien = Command.GetDataTable();

         var respone = new ResultModel
         {
            Data = JsonConvert.SerializeObject(tableNhanVien)

         };
         return Ok(respone);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }

   }

   // GET api/values
   //[Authorize]
   [HttpGet]
   [Route("api/getChecklists/{cardID}")]
   public IHttpActionResult GetChecklists(int cardID)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"SELECT checklists.ChecklistID,checklists.ChecklistTitle, checklistitems.Title FROM checklists
                                 INNER JOIN checklistitems ON checklists.ChecklistID = checklistitems.ChecklistID
                                 WHERE checklists.CardID = @cardID";
         Command.Parameters.AddWithValue("@cardID", cardID);
         DataTable tableChecklists = Command.GetDataTable();
         var respone = new ResultModel
         {
            Data = JsonConvert.SerializeObject(tableChecklists)
         };
         return Ok(respone);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }
   }



   [Route("api/searchBoards/{keyword}")]
   public IHttpActionResult SearchBoards(string keyword)
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"SELECT * FROM boards WHERE BoardName LIKE '%' + @Keyword + '%'";
         Command.Parameters.AddWithValue("@Keyword", keyword);
         DataTable tableBoards = Command.GetDataTable();

         var response = new ResultModel
         {
            Data = tableBoards
         };

         return Ok(response);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }
   }


   [Route("api/getNotifications")]
   public IHttpActionResult GetNotifications()
   {
      try
      {
         Command.ResetAndOpen(CommandType.Text);
         Command.CommandText = @"select notifications.NotificationID,notifications.NotificationType,Content,notifications.CreatedDate,users.Username,boards.BoardName,cards.CardName from notifications inner join users
on notifications.UserID = users.UserID
inner join cards
on notifications.CardID=cards.CardID
inner join boards
on notifications.BoardID=boards.BoardID
inner join lists
on notifications.BoardID=lists.BoardID";
         DataTable tableNhanVien = Command.GetDataTable();

         var respone = new ResultModel
         {
            Data = JsonConvert.SerializeObject(tableNhanVien)

         };
         return Ok(respone);
      }
      catch (Exception ex)
      {
         return Ok(ex.Message);
      }

   }
}
