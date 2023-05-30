using System;
using System.Web.Http;
using System.Data;
using Newtonsoft.Json;
using System.Security.Claims;
using System.Data.SqlClient;
using WebApiDemo.Models;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Net;
using System.Web;
using CsvHelper.Configuration;
using System.Globalization;
using System.Text;
using CsvHelper;
using System.Web.Razor.Tokenizer.Symbols;
using System.Net.Mail;

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



    [HttpPost]
    [Route("api/addUser")]
    public IHttpActionResult AddUser([FromBody] UserModel user)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO users (Username, Fullname, Password, Email, AvatarUrl)
                                 VALUES (@Username, @Fullname, @Password, @Email, @AvatarUrl)";

            Command.Parameters.AddWithValue("@Username", user.Username);
            Command.Parameters.AddWithValue("@Fullname", user.Fullname);
            Command.Parameters.AddWithValue("@Password", user.Password);
            Command.Parameters.AddWithValue("@Email", user.Email);
            Command.Parameters.AddWithValue("@AvatarUrl", user.AvatarUrl);

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
    [Route("api/updateUser/{userID}")]
    public IHttpActionResult UpdateUser(int userID, [FromBody] UserModel user)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"UPDATE users SET Username = @Username, Fullname=@Fullname, Password=@Password, Email=@Email, AvatarUrl=@AvatarUrl WHERE UserID = @UserID";
            Command.Parameters.AddWithValue("@Username", user.Username);
            Command.Parameters.AddWithValue("@Fullname", user.Fullname);
            Command.Parameters.AddWithValue("@Password", user.Password);
            Command.Parameters.AddWithValue("@Email", user.Email);
            Command.Parameters.AddWithValue("@AvatarUrl", user.AvatarUrl);

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

    //[HttpDelete]
    //[Route("api/deleteUser/{userId}")]
    //public IHttpActionResult DeleteUser(int userId)
    //{
    //    try
    //    {
    //        Command.ResetAndOpen(CommandType.Text);
    //        Command.CommandText = @"DELETE FROM users WHERE UserID = @UserID";
    //        Command.Parameters.AddWithValue("@UserID", userId);
    //        Command.ExecuteNonQuery();
    //        var response = new ResultModel { };
    //        return Ok(response);
    //    }
    //    catch (Exception ex)
    //    {
    //        return Ok(ex.Message);
    //    }
    //}




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

    [Route("api/getAccount")]
    public IHttpActionResult GetKien()
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

    [HttpDelete]
    [Route("api/deleteBoard/{boardId}")]
    public IHttpActionResult DeleteBoard(int boardId)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);

            Command.CommandText = @"DELETE FROM checklistitems WHERE CardID IN(SELECT CardID FROM cards where ListID IN(SELECT ListID FROM lists where BoardID=@checklistsBoardID))";
            Command.Parameters.AddWithValue("@checklistsBoardID", boardId);
            Command.ExecuteNonQuery();

            Command.CommandText = @"DELETE FROM attachments where CardID IN (SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID =@attachmentsBoardID))";
            Command.Parameters.AddWithValue("@attachmentsBoardID", boardId);
            Command.ExecuteNonQuery();

            Command.CommandText = @"delete from comments where CardID IN ( SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID =@commentsBoardID ))";
            Command.Parameters.AddWithValue("@commentsBoardID", boardId);
            Command.ExecuteNonQuery();

            Command.CommandText = @"delete from notifications where WHERE BoardID = @notificationsBoardID";
            Command.Parameters.AddWithValue("@notificationsBoardID", boardId);
            Command.ExecuteNonQuery();

            Command.CommandText = @"delete from creators WHERE BoardID=@creatorsBoardID";
            Command.Parameters.AddWithValue("@creatorsBoardID", boardId);
            Command.ExecuteNonQuery();

            Command.CommandText = @"delete from assignedTo WHERE BoardID=@assignedToBoardID";
            Command.Parameters.AddWithValue("@assignedToBoardID", boardId);
            Command.ExecuteNonQuery();

            Command.CommandText = @"delete from cards where ListID IN (SELECT ListID FROM lists WHERE BoardID = @CardBoardID)";
            Command.Parameters.AddWithValue("@CardBoardID", boardId);
            Command.ExecuteNonQuery();

            Command.CommandText = @"delete from lists where BoardID = @ListBoardID";
            Command.Parameters.AddWithValue("@ListBoardID", boardId);
            Command.ExecuteNonQuery();


            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"DELETE FROM boards WHERE BoardID = @BoardBoardID";
            Command.Parameters.AddWithValue("@BoardBoardID", boardId);

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
    public IHttpActionResult AddChecklistItem([FromBody] CheckListItemModel checklistitem)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO checklistitems (CardID, Title, Completed)
                                VALUES (@CardID, @Title, 0)";
            Command.Parameters.AddWithValue("@CardID", checklistitem.CardID);
            Command.Parameters.AddWithValue("@Title", checklistitem.Title);
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





    [HttpPost]
    [Route("api/addList")]
    public IHttpActionResult AddList([FromBody] ListModel list)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO lists (ListName, BoardID) VALUES (@ListName, @BoardID)";
            Command.Parameters.AddWithValue("@ListName", list.ListName);
            Command.Parameters.AddWithValue("@BoardID", list.BoardID);
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
            Command.CommandText = @"UPDATE cards SET 
CardName = @CardName,
DueDate = @DueDate,
Label = @Label,
LabelColor = @LabelColor
WHERE CardID = @CardID";
            Command.Parameters.AddWithValue("@CardName", card.CardName);
            Command.Parameters.AddWithValue("@Label", card.Label);
            Command.Parameters.AddWithValue("@LabelColor", card.LabelColor);
            Command.Parameters.AddWithValue("@DueDate", card.DueDate);
            Command.Parameters.AddWithValue("@CardID", cardID);
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
    [Route("api/updateList/{listID}")]
    public IHttpActionResult UpdateList(int listID, [FromBody] ListModel List)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"UPDATE lists SET 
ListName = @ListName
WHERE ListID = @ListID";
            Command.Parameters.AddWithValue("@ListName", List.ListName);
            Command.Parameters.AddWithValue("@ListID", listID);
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
    [Route("api/updatechecklistitem/{checklistitemID}")]
    public IHttpActionResult UpdateChecklistitem(int checklistitemID, [FromBody] CheckListItemModel checkListItem)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"UPDATE checklistitems SET 
Title = @Title,
Completed = @Completed
WHERE checklistitemID = @checklistitemID";
            Command.Parameters.AddWithValue("@Title", checkListItem.Title);
            Command.Parameters.AddWithValue("@Completed", checkListItem.Completed);
            Command.Parameters.AddWithValue("@checklistitemID", checklistitemID);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [Route("api/getCards/{userId}")]
    public IHttpActionResult GetCardsWithUserID(int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT cards.*,COUNT(comments.Detail) AS 'index_comment', COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
            FROM cards 
            LEFT JOIN checklistitems ON checklistitems.cardID = cards.cardID
			LEFT JOIN comments ON comments.cardID = cards.cardID
            WHERE cards.ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @UserID))
            GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
            cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
            cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
            cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
            ORDER BY cards.CardID DESC;";
            Command.Parameters.AddWithValue("@UserID", userID);

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


    [Route("api/searchCards/{keyword}/{userID}")]
    public IHttpActionResult SearchCards(string keyword, int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT cards.*,COUNT(comments.Detail) AS 'index_comment', COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
            FROM cards 
            LEFT JOIN checklistitems ON checklistitems.cardID = cards.cardID
			LEFT JOIN comments ON comments.cardID = cards.cardID
WHERE LOWER(CardName) LIKE '%' + @Keyword + '%' and cards.ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @UserID))
            GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
            cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
            cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
            cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
            ORDER BY cards.CardID DESC;";
            Command.Parameters.AddWithValue("@Keyword", keyword);
            Command.Parameters.AddWithValue("@UserID", userID);
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

    [Route("api/searchCheckList/{keyword}")]
    public IHttpActionResult SearchCheckList(string keyword)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT * FROM checklistitems WHERE LOWER(checklistitems.Title) LIKE '%' + @Keyword + '%'";
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




    // GET api/values
    //[Authorize]
    [Route("api/getboards/{userID}")]
    public IHttpActionResult GetBoards(int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"select * from boards WHERE boards.userID = @userID";
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

    // GET api/values
    //[Authorize]


    // GET api/values
    //[Authorize]
    //    [HttpGet]
    //    [Route("api/getCards/{listID}")]
    //    public IHttpActionResult GetChecklists(int listID)
    //    {
    //        try
    //        {
    //            Command.ResetAndOpen(CommandType.Text);
    //            Command.CommandText = @"SELECT cards.*, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
    //FROM cards
    //LEFT JOIN checklists ON cards.cardID = checklists.cardID
    //LEFT JOIN checklistitems ON checklists.checklistID = checklistitems.checklistID
    //WHERE cards.ListID = @listID
    //GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist,
    //cards.Label, cards.Comment, cards.CardName, cards.StatusView,
    //cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
    //cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor";
    //            Command.Parameters.AddWithValue("@listID", listID);
    //            DataTable tableChecklists = Command.GetDataTable();
    //            var respone = new ResultModel
    //            {
    //                Data = JsonConvert.SerializeObject(tableChecklists)
    //            };
    //            return Ok(respone);
    //        }
    //        catch (Exception ex)
    //        {
    //            return Ok(ex.Message);
    //        }
    //    }



    [HttpPost]
    [Route("api/addCard")]
    public IHttpActionResult AddCard([FromBody] CardModel card)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO cards (ListID, CreatorID, CardName, Label, Comment, CreatedDate, DueDate, LabelColor)
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


    [HttpGet]
    [Route("api/getChecklists/{cardID}")]
    public IHttpActionResult GetCardsList(int cardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT checklistitems.*,cards.CardName from checklistitems 
INNER JOIN cards on cards.CardID = checklistitems.CardID
where checklistitems.CardID = @cardID";
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

    [Route("api/getcards")]
    public IHttpActionResult GetCards()
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT cards.*, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards
LEFT JOIN checklistitems ON checklistitems.CardID = cards.CardID
GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
ORDER BY cards.CardID DESC";
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

    [Route("api/getcarddetail/{cardID}")]
    public IHttpActionResult GetCardDetail(int cardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT *
FROM cards
LEFT JOIN lists ON cards.ListID = lists.ListID
WHERE cards.CardID = @cardID;";
            Command.Parameters.AddWithValue("@cardID", cardID);
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

    [Route("api/sortCard/{userId}")]
    public IHttpActionResult GetSortCard(int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT cards.*,COUNT(comments.Detail) AS 'index_comment', COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards
LEFT JOIN checklistitems ON checklistitems.CardID = cards.CardID
LEFT JOIN comments ON comments.cardID = cards.cardID
WHERE cards.ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @UserID))
GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
ORDER BY cards.DueDate ASC;";

            Command.Parameters.AddWithValue("@UserID", userID);
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

    [Route("api/sortCardLabel/{userId}")]
    public IHttpActionResult GetSortCardLabel(int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT cards.*,
       COUNT(comments.Detail) AS 'index_comment',
       COUNT(checklistitems.ChecklistItemID) AS 'SUM',
       SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards
LEFT JOIN checklistitems ON checklistitems.CardID = cards.CardID
LEFT JOIN comments ON comments.cardID = cards.cardID
WHERE cards.ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @UserID))
GROUP BY cards.CardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist,
         cards.Label, cards.Comment, cards.CardName, cards.StatusView,
         cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
         cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor, comments.Detail
ORDER BY cards.LabelColor ASC;";

            Command.Parameters.AddWithValue("@UserID", userID);
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

    [HttpGet]
    [Route("api/getLists/{boardID}")]
    public IHttpActionResult GetLists(int boardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT * FROM lists
                                 INNER JOIN cards ON lists.ListID = cards.ListID
                                 WHERE lists.BoardID = @boardID";
            Command.Parameters.AddWithValue("@boardID", boardID);
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

    [HttpGet]
    [Route("api/getAllListOption/{userID}")]
    public IHttpActionResult GetAllListOption(int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"Select * from users 
INNER JOIN boards on users.UserID = boards.UserID
INNER JOIN lists on lists.BoardID = boards.BoardID
Where users.UserID = @userID";
            Command.Parameters.AddWithValue("@userID", userID);
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

    [HttpGet]
    [Route("api/getListOption/{boardID}")]
    public IHttpActionResult GetListOption(int boardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"Select * from lists where BoardID= @boardID";
            Command.Parameters.AddWithValue("@boardID", boardID);
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

    [Route("api/searchBoards/{keyword}/{userID}")]
    public IHttpActionResult SearchBoards(string keyword, int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT *
FROM boards
WHERE LOWER(boards.BoardName) LIKE '%' + @Keyword + '%' and boards.UserID = @userID";
            Command.Parameters.AddWithValue("@Keyword", keyword);
            Command.Parameters.AddWithValue("@userID", userID);
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

    [Route("api/getComments/{cardID}")]
    public IHttpActionResult GetComments(int cardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"select users.UserID, users.AvatarUrl, users.Fullname, comments.Detail, comments.CommentID from users inner join comments
                                    on users.UserID = comments.UserID
                                    where comments.CardID= @cardID order by comments.CommentID DESC";

            Command.Parameters.AddWithValue("@cardID", cardID);
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

    [HttpPost]
    [Route("api/addComment")]
    public IHttpActionResult AddComment([FromBody] CommentModel comment)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO comments (UserID, CardID, Detail)
                                 VALUES (@UserID, @CardID, @Detail)";
            Command.Parameters.AddWithValue("@UserID", comment.UserID);
            Command.Parameters.AddWithValue("@CardID", comment.CardID);
            Command.Parameters.AddWithValue("@Detail", comment.Detail);

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
    [Route("api/deleteComment/{commentID}")]
    public IHttpActionResult DeleteComment(int commentID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"DELETE FROM comments WHERE CommentID = @CommentID";
            Command.Parameters.AddWithValue("@CommentID", commentID);
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
    [Route("api/updateComment/{userID}/{commentID}")]
    public IHttpActionResult UpdateComment(int userID, int commentID, [FromBody] CommentModel comment)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"UPDATE comments SET Detail = @Detail WHERE CommentID = @CommentID AND UserID= @UserID";
            Command.Parameters.AddWithValue("@Detail", comment.Detail);

            Command.Parameters.AddWithValue("@CommentID", comment.CommentID);
            Command.Parameters.AddWithValue("@UserID", comment.UserID);


            Command.ExecuteNonQuery();
            var response = new ResultModel { };
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
            Command.CommandText = @"SELECT DISTINCT notifications.NotificationID, notifications.NotificationType, notifications.Content, notifications.CreatedDate, users.Username, boards.BoardName, cards.CardName, cards.CardID, boards.BoardID, boards.Labels
FROM notifications
INNER JOIN users ON notifications.UserID = users.UserID
INNER JOIN cards ON notifications.CardID = cards.CardID
INNER JOIN boards ON notifications.BoardID = boards.BoardID
INNER JOIN lists ON notifications.BoardID = lists.BoardID
ORDER BY notifications.NotificationID DESC";
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

    [Route("api/getCountUnread")]
    public IHttpActionResult GetCountUnread()
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT COUNT(*) AS 'CountNotify' FROM notifications WHERE notifications.Status = 0;";
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

    [Route("api/acceptNotify")]
    public IHttpActionResult GetacceptNotify()
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"UPDATE notifications SET Status = 1";
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


    [HttpGet]
    [Route("api/downloadfile")]
    public IHttpActionResult DownloadFile()
    {
        try
        {
            var fileName = "data.csv";
            var filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, fileName);

            if (!File.Exists(filePath))
            {
                return NotFound();
            }

            var fileContent = File.ReadAllBytes(filePath);

            var contentDisposition = new System.Net.Mime.ContentDisposition
            {
                FileName = fileName,
                Inline = false
            };
            HttpContext.Current.Response.Headers.Add("Content-Disposition", contentDisposition.ToString());

            var result = new HttpResponseMessage(HttpStatusCode.OK);
            result.Content = new ByteArrayContent(fileContent);
            result.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
            return ResponseMessage(result);
        }
        catch (Exception ex)
        {
            return InternalServerError(ex);
        }
    }

    [Route("api/writecsv/{userId}")]
    public IHttpActionResult GetFileCSV(int userId)
    {
        try
        {
            // Configure the CSV writer
            var config = new CsvConfiguration(CultureInfo.InvariantCulture)
            {
                Encoding = Encoding.UTF8,
                Delimiter = ","
            };

            // Write the data to a stream
            using (var memoryStream = new MemoryStream())
            using (var streamWriter = new StreamWriter(memoryStream, Encoding.UTF8))
            using (var csvWriter = new CsvWriter(streamWriter, config))
            {
                csvWriter.WriteField(userId.ToString());
                csvWriter.NextRecord();
                streamWriter.Flush();

                // Save the stream to a file
                var fileName = "data.csv";
                var filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, fileName);
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    memoryStream.Seek(0, SeekOrigin.Begin);
                    memoryStream.CopyTo(fileStream);
                }

                // Return the file content to the client
                var csvContent = File.ReadAllText(filePath);
                return Ok(csvContent);
            }
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [Route("api/getAttachments/{cardID}")]
    public IHttpActionResult GetAttachments(int cardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"select * from attachments
                                    where attachments.CardID= @cardID order by attachments.AttachmentID DESC";

            Command.Parameters.AddWithValue("@cardID", cardID);
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

    [HttpPost]
    [Route("api/addAttachment")]
    public IHttpActionResult UpdateAttachment([FromBody] AttachmentModel attachment)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO attachments(CardID, AttachmentPath, AttachmentName)
                                    VALUES(@CardID, @AttachmentPath, @AttachmentName)";

            Command.Parameters.AddWithValue("@CardID", attachment.CardID);
            Command.Parameters.AddWithValue("@AttachmentPath", attachment.AttachmentPath);
            Command.Parameters.AddWithValue("@AttachmentName", attachment.AttachmentName);



            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }



    [Route("api/getUser/{email}")]
    public IHttpActionResult GetUser(string email)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"Select * from users where users.Email = @email";

            Command.Parameters.AddWithValue("@email", email);
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

    [HttpDelete]
    [Route("api/deleteAttachment/{attachmentID}")]
    public IHttpActionResult DeleteAttachment(int attachmentID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"DELETE FROM attachments WHERE AttachmentID = @AttachmentID";
            Command.Parameters.AddWithValue("@AttachmentID", attachmentID);
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
    [Route("api/changePassword/{userID}")]
    public IHttpActionResult UpdatePassword(int userID, [FromBody] UserModel user)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"UPDATE users SET Password=@Password WHERE UserID = @UserID";

            Command.Parameters.AddWithValue("@Password", user.Password);

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
    [Route("api/searchLists/{keyword}")]
    public IHttpActionResult SearchLists(string keyword)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT * FROM lists WHERE ListName LIKE '%' + @Keyword + '%'";
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


    [HttpDelete]
    [Route("api/deleteMember/{memberID}")]
    public IHttpActionResult DeleteMember(int memberID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"DELETE FROM members WHERE members.id = @memberID";
            Command.Parameters.AddWithValue("@memberID", memberID);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [Route("api/getmembers/{cardID}")]
    public IHttpActionResult GetMember(int cardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"Select * from members 
                Where members.assignedTo = ( select members.assignedTo from cards where CardID = @CardID )";

            Command.Parameters.AddWithValue("@CardID", cardID);
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

    [HttpPost]
    [Route("api/addMember")]
    public IHttpActionResult AddMember([FromBody] MemberModel member)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO members(fullname, Email, AvatarUrl, assignedTo)
                                    VALUES(@fullname, @Email, @AvatarUrl, @assignedTo)";

            Command.Parameters.AddWithValue("@fullname", member.fullname);
            Command.Parameters.AddWithValue("@Email", member.Email);
            Command.Parameters.AddWithValue("@AvatarUrl", member.AvatarUrl);
            Command.Parameters.AddWithValue("@assignedTo", member.assignedTo);


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
    [Route("api/deleteUser/{userId}")]
    public IHttpActionResult DeleteUser(int userId)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);

            // Delete related records from checklistitems
            Command.CommandText = @"DELETE FROM checklistitems WHERE CardID IN (SELECT CardID FROM cards WHERE ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID=@ChecklistUserID)))";
            Command.Parameters.AddWithValue("@ChecklistUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from attachments
            Command.CommandText = @"DELETE FROM attachments WHERE CardID IN (SELECT CardID FROM cards WHERE ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID=@AttachmentUserID)))";
            Command.Parameters.AddWithValue("@AttachmentUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from comments foreign key CardID
            Command.CommandText = @"delete from comments where CardID IN ( SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID IN(SELECT BoardID FROM boards WHERE UserID=@CommentUserID)))";
            Command.Parameters.AddWithValue("@CommentUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from comments foreign key UserID
            Command.CommandText = @"delete from comments where UserID= @FkCommentUserID";
            Command.Parameters.AddWithValue("@FkCommentUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from notifications foreign key CardID
            Command.CommandText = @"delete from notifications where CardID IN ( SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID IN(SELECT BoardID FROM boards WHERE UserID=@NotificationUserID)))";
            Command.Parameters.AddWithValue("@NotificationUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from notifications foreign key BoardID
            Command.CommandText = @"delete from notifications where BoardID IN (SELECT BoardID FROM boards WHERE UserID= @FkBoardNotificationUserID)";
            Command.Parameters.AddWithValue("@FkBoardNotificationUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from notifications foreign key UserID
            Command.CommandText = @"delete from notifications where UserID = @FkUserNotificationUserID";
            Command.Parameters.AddWithValue("@FkUserNotificationUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from creator
            Command.CommandText = @"delete from creators WHERE UserID=@CreatorUserID";
            Command.Parameters.AddWithValue("@CreatorUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from assignedTo
            Command.CommandText = @"delete from assignedTo WHERE UserID= @AssignedToUserID";
            Command.Parameters.AddWithValue("@AssignedToUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from cards
            Command.CommandText = @"DELETE FROM cards WHERE ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @CardUserID))";
            Command.Parameters.AddWithValue("@CardUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from lists
            Command.CommandText = @"DELETE FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @ListUserID)";
            Command.Parameters.AddWithValue("@ListUserID", userId);
            Command.ExecuteNonQuery();

            Command.CommandText = @"delete from creators WHERE UserID= @creatorsUserID";
            Command.Parameters.AddWithValue("@creatorsUserID", userId);
            Command.ExecuteNonQuery();

            Command.CommandText = @"delete from assignedTo WHERE BoardID=@assignedToUserID";
            Command.Parameters.AddWithValue("@assignedToUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from boards
            Command.CommandText = @"DELETE FROM boards WHERE UserID = @BoardUserID";
            Command.Parameters.AddWithValue("@BoardUserID", userId);
            Command.ExecuteNonQuery();

            // Finally, delete the user record
            Command.CommandText = @"DELETE FROM users WHERE UserID = @UserUserID";
            Command.Parameters.AddWithValue("@UserUserID", userId);
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
    [Route("api/deleteCard/{cardId}")]
    public IHttpActionResult DeleteCard(int cardId)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);

            // Delete related records from checklistitems
            Command.CommandText = @"DELETE FROM checklistitems WHERE CardID=@ChecklistCardID";
            Command.Parameters.AddWithValue("@ChecklistCardID", cardId);
            Command.ExecuteNonQuery();

            // Delete related records from attachments
            Command.CommandText = @"DELETE FROM attachments WHERE CardID = @AttachmentCardID";
            Command.Parameters.AddWithValue("@AttachmentCardID", cardId);
            Command.ExecuteNonQuery();

            // Delete related records from comments
            Command.CommandText = @"DELETE FROM comments WHERE CardID=@CommentCardID";
            Command.Parameters.AddWithValue("@CommentCardID", cardId);
            Command.ExecuteNonQuery();

            // Delete related records from notifications
            Command.CommandText = @"DELETE FROM notifications WHERE CardID=@NotificationCardID";
            Command.Parameters.AddWithValue("@NotificationCardID", cardId);
            Command.ExecuteNonQuery();

            // Delete related records from cards
            Command.CommandText = @"DELETE FROM cards WHERE CardID = @CardCardID";
            Command.Parameters.AddWithValue("@CardCardID", cardId);
            Command.ExecuteNonQuery();

            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }
    [Route("api/get3FirstBoards/{userID}")]
    public IHttpActionResult GetThreeFirstBoards(int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT TOP 3 * FROM boards where UserID= @userID ORDER BY BoardID DESC";
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
}