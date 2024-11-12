import java.util.Collections;
import java.util.ArrayList;
import http.requests.*;
PostRequest runQuery;

Table table;
PFont notoFont;
String[] username={"Sarah","Thompson","Alex","Murphy","Emily"}; 
int[] useratk={72,15,82,30,12};


void setup() {
  size(1024, 800);

  // 設置字體
  notoFont = createFont("NotoSansTC-VariableFont_wght.ttf", 20);
  textFont(notoFont);

  //i can't use it and i don't know why
  //String url = "https://docs.google.com/spreadsheets/d/122ZgnKyqjSnjyRYCTU5RT_9p02f1BIwHHFVwwN4HZbY/export?format=csv&gid=1388974091";
  //table = loadTable(url, "header");

  // 使用 loadStrings() 讀取 CSV
  String url = "https://docs.google.com/spreadsheets/d/122ZgnKyqjSnjyRYCTU5RT_9p02f1BIwHHFVwwN4HZbY/export?format=csv&gid=1388974091";
  String[] rows = loadStrings(url);

  // 檢查是否成功載入
  if (rows == null || rows.length == 0) {
    println("Failed to load table or table is empty.");
    return;
  } else {
    println("Table loaded successfully!");
  }

  // 手動轉換為 Table
  table = new Table();

  // 設置欄位標題
  String[] headers = split(rows[0], ',');
  for (String header : headers) {
    table.addColumn(header);
  }

  // 將每列數據加入 Table
  for (int i = 1; i < rows.length; i++) {
    TableRow newRow = table.addRow();
    String[] values = split(rows[i], ',');
    for (int j = 0; j < values.length; j++) {
      newRow.setString(headers[j], values[j].replace("\"", ""));
    }
  }

  // 檢查 table 是否成功建立
  if (table.getRowCount() == 0) {
    println("No rows in table.");
    return;
  }

}
void draw(){
  background(255);
  
  int i = int(random(0,4));
  if(mousePressed){
    sendForm(username[i],String.valueOf(useratk[i]));
  }
  
  textSize(20);
  fill(0);
  text("name:"+username[i],200,100);
  text("atk:"+useratk[i],200,130);
  text("press your mouse to store the data",200,160);
  text("press s(or S) to show the stored data",200 ,200);
  
  
  if(keyPressed){
    if(key == 's' || key == 'S'){
      displayTable();
    }
  }
}

void displayTable() {
  background(255);
  fill(0);
  textSize(18);

  float x = 50; // 左側邊距
  float y = 50; // 上側邊距
  float rowHeight = 25; // 每列高度
  float colWidth = 200; // 每欄間距加大到 200px

  // 顯示表頭
  for (int i = 0; i < table.getColumnCount(); i++) {
    String title = table.getColumnTitle(i);
    if (title != null) { // 避免 NullPointerException
      text(title, x + i * colWidth, y);
    }
  }

  // 顯示每行資料
  for (TableRow row : table.rows()) {
    y += rowHeight;
    for (int i = 0; i < table.getColumnCount(); i++) {
      String value = row.getString(i);
      if (value != null) { // 避免 NullPointerException
        text(value, x + i * colWidth, y);
      }
    }
    // 若畫面超出高度，自動停止顯示
    if (y > height - rowHeight) {
      break;
    }
  }
}


//https://docs.google.com/forms/d/e/1FAIpQLSebL8SD2HUPGrtVaATXuAcwcTe-j0dMOf4Qm4ogWePv7fmJFg/viewform?usp=pp_url&entry.551026018={ }&entry.362372410={ }
//save data to cloud
void sendForm(String m_username,String m_useratk){
  String SendUrl="https://docs.google.com/forms/d/e/1FAIpQLSebL8SD2HUPGrtVaATXuAcwcTe-j0dMOf4Qm4ogWePv7fmJFg/formResponse?usp=pp_url";
  String data = "&entry.551026018="+m_username+"&entry.362372410="+m_useratk;
  String googleFormUrl = SendUrl+data;
  
  googleFormUrl = googleFormUrl.replace(" ","%20");
  
  println("request :",googleFormUrl,"success");
  
  runQuery = new PostRequest(googleFormUrl);
  runQuery.send();
}
