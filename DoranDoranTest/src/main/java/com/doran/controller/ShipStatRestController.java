package com.doran.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.doran.entity.tbl_shipstat;
import com.doran.mapper.tbl_shipstatMapper;

@RestController
@RequestMapping("/ship")
public class ShipStatRestController {

   @Autowired
   private tbl_shipstatMapper shipstatMapper;

   // 특정 선박 통계 조회
   @GetMapping("/{siNum}")
   public tbl_shipstat getShipStat(@PathVariable("siNum") int siNum) {
      return shipstatMapper.getShipStat(siNum);
   }

}
