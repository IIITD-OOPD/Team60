package neeti;

import java.io.File;
import java.io.IOException;

import java.sql.ResultSet;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import java.util.*;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.*;
import org.apache.commons.fileupload.servlet.*;
import org.w3c.dom.*;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;




public class UploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	 private final String UPLOAD_DIRECTORY = "C://Users//user//Desktop//Team_60";
	 String name="";
	DBConnection db = new DBConnection("com.mysql.jdbc.Driver","jdbc:mysql://localhost:3306/","oopd","root","");
	    /**
	     * 
	     * @see HttpServlet#HttpServlet()
	     */
	    public UploadServlet() {
	        super();
	        // TODO Auto-generated constructor stub
	    }
	    /**
	     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	     */
	    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        // TODO Auto-generated method stub
	        response.getWriter().append("Served at: ").append(request.getContextPath());
	    }

	    /**
	     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	     */
	    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	      
	        
	        if(ServletFileUpload.isMultipartContent(request)){
	            try {
	               
	                List<FileItem> multiparts = new ServletFileUpload(
	                                         new DiskFileItemFactory()).parseRequest(request);
	              
	                for(FileItem item : multiparts){
	                    if(!item.isFormField()){
	                        name = new File(item.getName()).getName();
	                        item.write( new File(UPLOAD_DIRECTORY + File.separator + name));
	                    }
	                }
	           
	               //File uploaded successfully
	               request.setAttribute("message", "File Uploaded Successfully");
	            } catch (Exception ex) {
	               request.setAttribute("message", "File Upload Failed due to " + ex);
	            }          
	         
	        }else{
	            request.setAttribute("message",
	                                 "Sorry this Servlet only handles file upload request");
	        }
	        
	        int circuit_id=-1;
	        try{
	        	System.out.println("inserting...");
	        	StringTokenizer st = new StringTokenizer(name,".");
	        	String file_name = st.nextToken();
	        	db.executeDDLOrDML("Insert into circuits(CircuitName) values('"+file_name+"')", 123);
	        	ResultSet r = db.executeSelect("select idCircuits from circuits where CircuitName='"+file_name+"'", 111);
	        	
	        	while (r.next()) { 
	        		circuit_id = Integer.parseInt(r.getString(1)); 
	        	}
	        	
	        	request.setAttribute("id", circuit_id);
		    	 DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
		         DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();	         
		         Document doc = docBuilder.parse (new File("C://Users//user//Desktop//Team_60//"+name));	        
		         doc.getDocumentElement().normalize();	         
		         Element root = doc.getDocumentElement();   
		         
		         NodeList inputList = doc.getElementsByTagName("input-point");
		         NodeList gates = doc.getElementsByTagName("gate");
		         NodeList outputList = doc.getElementsByTagName("output-point");
		       
		        // db.releaseResources();
		         
		         for(int i=0;i < inputList.getLength();i++) {
		             Element input = (Element) inputList.item(i);
		             int input_id = Integer.parseInt(input.getAttribute("id"));
		             String label =  input.getAttribute("label");
		             db.executeDDLOrDML("Insert into elements(element_id,element_type,label,circuit_id) values('"+input_id+"','input','"+label+"','"+circuit_id+"')", 134);
		         }
		         for(int i=0;i < gates.getLength();i++) {
		             Element gate = (Element) gates.item(i);
		             int gate_id = Integer.parseInt(gate.getAttribute("id"));
		             String label = gate.getAttribute("type");
		             Element input1 = (Element) gate.getElementsByTagName("input-source").item(0);		           		             
		             Element input2 = (Element) gate.getElementsByTagName("input-source").item(1);
		             String input1_type = input1.getAttribute("type");
		             String input2_type = input2.getAttribute("type");
		             String input1_id = input1.getAttribute("id");
		             String input2_id = input2.getAttribute("id");
		             db.executeDDLOrDML("Insert into elements(element_id,element_type,label,input1_type,input2_type,circuit_id,input1_id,input2_id) values('"+gate_id+"','gate','"+label+"','"+input1_type+"','"+input2_type+"','"+circuit_id+"','"+input1_id+"','"+input2_id+"')", 134);
		            
		         }
		         for(int i=0;i < outputList.getLength();i++) {
		             Element output = (Element) outputList.item(i);
		             int output_id = Integer.parseInt(output.getAttribute("id"));
		             String label =  output.getAttribute("label");
		             Element input1 = (Element) output.getElementsByTagName("input-source").item(0);
		             String input1_type = input1.getAttribute("type");
		             String input1_id = input1.getAttribute("id");
		             db.executeDDLOrDML("Insert into elements(element_id,element_type,label,input1_type,circuit_id,input1_id) values('"+output_id+"','output','"+label+"','"+input1_type+"','"+circuit_id+"','"+input1_id+"')", 134);
		         }
		         db.releaseResources();
		    	}
		    	catch(IOException e){}
		    	catch (SAXParseException err) {
		            System.out.println ("** Parsing error" + ", line " + err.getLineNumber () + ", uri " + err.getSystemId ());
		            System.out.println(" " + err.getMessage ());

		            }catch (SAXException e) {
		            Exception x = e.getException ();
		            ((x == null) ? e : x).printStackTrace ();

		            }catch (Throwable t) {
		            t.printStackTrace ();
		            }
	        
	        request.getRequestDispatcher("/Circuit.jsp").forward(request, response);
	     
	    }
	   
}

