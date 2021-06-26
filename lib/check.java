class Update_user extends AsyncTask<String, Void, String>
            {
                Context ctx;
                public Update_user(Context ctx)
                {
                    this.ctx = ctx;
                }
                @Override
                protected String doInBackground(String... params) {
                    StringBuilder sb = null;
                    BufferedReader reader = null;
                    String serverResponse = null;
                    try {
                        //run it wait
                        String username = params[0].toString();
                        String phone = params[1].toString();
                        String email = params[2].toString();
                        String surname = params[3].toString(); //this will shop..ok
                        String address1 = params[4].toString();
                        String address2 = params[5].toString();
                        /*
                        *  This class is to update the user in backend
                        * */

                        String gstn = params[6].toString();
                        String password2="12345";
                        String password1="12345";
                        String token="1928765456";
                        String reg_url="http://mypim.in/Android/Myapi/updateprofile/"+phone+"?token=1928765456";
                        URL url = new URL(reg_url);

                        HttpURLConnection cn=(HttpURLConnection) url.openConnection();
                        cn.setRequestMethod("POST");
                        cn.setDoOutput(true);
                        OutputStream OS = cn.getOutputStream();
                        BufferedWriter br = new BufferedWriter(new OutputStreamWriter(OS,"UTF-8"));
                        String data = URLEncoder.encode("username", "UTF-8") + "=" + URLEncoder.encode(username, "UTF-8")
                                +"&"+ URLEncoder.encode("phone", "UTF-8") + "=" + URLEncoder.encode(phone, "UTF-8")
                                +"&"+ URLEncoder.encode("email", "UTF-8") + "=" + URLEncoder.encode(email, "UTF-8")
                                +"&"+ URLEncoder.encode("address1", "UTF-8") + "=" + URLEncoder.encode(address1, "UTF-8")
                                +"&"+ URLEncoder.encode("address2", "UTF-8") + "=" + URLEncoder.encode(address2, "UTF-8")
                                +"&"+ URLEncoder.encode("surname", "UTF-8") + "=" + URLEncoder.encode(surname, "UTF-8")
                                +"&"+ URLEncoder.encode("gstn", "UTF-8") + "=" + URLEncoder.encode(gstn, "UTF-8")
                                +"&"+ URLEncoder.encode("password2", "UTF-8") + "=" + URLEncoder.encode(password2, "UTF-8")
                                +"&"+ URLEncoder.encode("password1", "UTF-8") + "=" + URLEncoder.encode(password1, "UTF-8")
                                +"&"+ URLEncoder.encode("token", "UTF-8") + "=" + URLEncoder.encode(token, "UTF-8")



                                ;
                        System.out.println("data :"+data);
                        System.out.println(reg_url);
                        br.write(data);
                        br.flush();
                        br.close();
                        OS.close();
                       // System.out.println("OK");
                        InputStream stream=cn.getInputStream();
                        stream.close();
                        return "true";
                    }
                    catch (Exception e)
                    {
                        return "Error: "+e;
                    }
                }

                protected void onPostExecute(String  result)
                {
                    if(result.equals("true")) {
                        Toast.makeText(ctx, "Your Profile has been updated.", Toast.LENGTH_LONG).show();
                        cname.setEnabled(false);
                        cemail.setEnabled(false);
                        cshop.setEnabled(false);
                        c_bill_add.setEnabled(false);
                        c_ship_add.setEnabled(false);
                        c_gst_num.setEnabled(false);
                    }
                    else {
                        Toast.makeText(ctx, "Error "+result, Toast.LENGTH_LONG).show();
                    }
                }
            }