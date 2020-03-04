$(function(){
  // カテゴリーセレクトボックスのオプションを作成
  function appendOption(category){
    let html = `<option value="${category.id}" data-category="${category.id}">${category.name}</option>`;
    return html;
  }
  // サイズボックスのオプションを作成
  function appendSizeOption(category){
    let html = `<option value="${category.id}" data-category="${category.id}">${category.size}</option>`;
    return html;
  }
  // カテゴリー2の表示作成
  function appendCategory2Box(insertHTML){
    const html = `<select required="required" class="select_form" id= 'category2-form'>
                    <option value="">選択してください</option>
                    ${insertHTML}
                  </select>`;
    return html;
  }
  // カテゴリー3の表示作成
  function appendCategory3Box(insertHTML){
    const html = `<select required="required" class="select_form" name= 'item[category_id]'  id= 'category3-form'>
                    <option value="">選択してください</option>
                    ${insertHTML}
                  </select>`;
    return html;
  }
  // サイズの表示作成
  function appendSizeBox(insertHTML){
    const html = `<div id="size-box">
                    <div class="container__sell-main__sell-box__item-container__cleafix__form-box__form-any">
                      <P>サイズ</P><span>任意</span>
                    </div>
                    <div class="container__sell-main__sell-box__item-container__cleafix__form-box__select">
                      <select class="select_form" name= 'item[size_id]'  id= 'size-box'>
                      <option value="">選択してください</option>
                      ${insertHTML}
                      </select>
                    </div>
                  </div>`;
    return html;
  }
  // ブランドの表示作成
  function appendBrandBox(){
    const html = `<div id="brand-box">
                    <div class="container__sell-main__sell-box__item-container__cleafix__form-box__form-any">
                      <p>ブランド</p><span>任意</span>
                    </div>
                    <div class="container__sell-main__sell-box__item-container__cleafix__form-box__form-brand">
                      <input placeholder="ブランド名" class="select_form" type="text" value="" name="brand[name]" id="brand_name">
                    </div>
                  </div>`;
    return html;
  }
  // カテゴリー1選択後のイベント
  $('#item_category_id').on('change', function(){
    var Category1Id = $('#category1-box option:selected').val();  //選択されたカテゴリー1のIDを取得
    if (Category1Id != ""){ //親カテゴリーが初期値でないことを確認
      $.ajax({
        url: '/items/get_category2',
        type: 'GET',
        data: { category1_id: Category1Id },
        dataType: 'json'
      })
      .done(function(category2s){
        $('#category2-form').remove(); //親が変更された時、子以下を削除するする
        $('#category3-form').remove();
        $('#size-box').remove();
        $('#brand-box').remove();
        let insertHTML = '';
        category2s.forEach(function(category2){
          insertHTML += appendOption(category2);
        });
        $('#category1-box').append(appendCategory2Box(insertHTML));

      })
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    }else{
      $('#category2-form').remove(); //親カテゴリーが初期値になった時、子以下を削除するする
      $('#category3-form').remove();
      $('#size-box').remove();
      $('#brand-box').remove();
    }
  });
  // カテゴリー2選択後のイベント
  $('.category-box').on('change', '#category2-form',function(){
    var Category2Id = $('#category2-form option:selected').val();  //選択されたカテゴリー2のIDを取得
    if (Category2Id != ""){ //親カテゴリーが初期値でないことを確認
      $.ajax({
        url: '/items/get_category3',
        type: 'GET',
        data: { category2_id: Category2Id },
        dataType: 'json'
      })
      .done(function(category3s){
        $('#category3-form').remove(); //親が変更された時、子以下を削除するする
        $('#size-box').remove();
        $('#brand-box').remove();
        let insertHTML = '';
        category3s.forEach(function(category3){
          insertHTML += appendOption(category3);
        });
        $('#category1-box').append(appendCategory3Box(insertHTML));
        $('#after_brand').before(appendBrandBox());
      })
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    }else{
      $('#category3-form').remove(); //カテゴリー3が初期値になった時、子以下を削除するする
      $('#size-box').remove();
      $('#brand-box').remove();
    }
  });
  // カテゴリー3選択後のイベント
  $('.category-box').on('change', '#category3-form',function(){
    var Category3Id = $('#category3-form option:selected').val();  //選択されたカテゴリー3のIDを取得
    if (Category3Id != ""){ //親カテゴリーが初期値でないことを確認
      $.ajax({
        url: '/items/get_size',
        type: 'GET',
        data: { category3_id: Category3Id },
        dataType: 'json'
      })
      .done(function(sizes){
        $('#size-box').remove();
        let insertHTML = '';
        sizes.forEach(function(size){
          insertHTML += appendSizeOption(size);
        });
        $('#category-list').after(appendSizeBox(insertHTML));
      })
    }else{
      $('#size-box').remove();
    }
  });
});