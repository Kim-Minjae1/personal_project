package com.personal.spring.member.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class Member{
private int user_no;
private String user_id;
private String user_pw;
private String user_name;
private String user_address;
} 
