$(document).ready(function() {
      $('#province_select').change(function() {
        $.ajax({
        url: "<%= update_cantons_path %>",
        data: {
          province_id : $('#province_select').val()
        },
        dataType: "script"
        });
      });
    });


$('#canton_select').change(function() {
        $.ajax({
        url: "<%= update_parishes_path %>",
        data: {
          canton_id : $('#canton_select').val()
        },
        dataType: "script"
        });
      });