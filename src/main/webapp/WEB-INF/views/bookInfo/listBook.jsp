<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="/resources/js/jquery-3.6.0.js"></script>

<!-- data = ArticlePage.java-->

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">DataTables Example</h6>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <div id="dataTable_wrapper" class="dataTables_wrapper dt-bootstrap4">
                <!-- default: action:현재 위치 method:get -->
                <form action="/bookInfo/listBook" method="get" id="frm" name="frm">
                    <div class="row">
                        <div class="col-sm-12 col-md-6">
                            <div class="dataTables_length" id="dataTable_length">
                                <!--
                                    select: selected
                                    radio: checked
                                    checkbox: checked
                                -->
                                <label>SIZE
                                    <select id="selSize" name="size"
                                                    aria-controls="dataTable"
                                                    class="custom-select custom-select-sm form-control form-control-sm">
                                    <option value="10" <c:if test="${param.size=='10'}">selected</c:if>>10</option>
                                    <option value="25" <c:if test="${param.size=='25'}">selected</c:if>>25</option>
                                    <option value="50" <c:if test="${param.size=='50'}">selected</c:if>>50</option>
                                    <option value="100" <c:if test="${param.size=='100'}">selected</c:if>>100</option></select> entries
                                </label>
                            </div>
                        </div>
                        <div class="col-sm-12 col-md-6">
                            <div id="dataTable_filter" class="dataTables_filter">
                                <label>Search:<input type="text" name="keyword"
                                                     value="${param.keyword}"
                                                     class="form-control form-control-sm" placeholder="검색어를 입력해주세요."
                                                     aria-controls="dataTable"></label>
                                <label>
                                    <button type="submit" class="btn btn-primary btn-icon-split">
                                        <span class="icon text-white-50">
                                            <i class="fas fa-flag"></i>
                                        </span>
                                        <span class="text">검색</span>
                                    </button>
                                </label>
                            </div>
                        </div>
                    </div>
                </form>
                <div class="row">
                    <div class="col-sm-12">
                        <table class="table table-bordered dataTable" id="dataTable"
                               width="100%" cellspacing="0" role="grid"
                               aria-describedby="dataTable_info" style="width: 100%;">
                            <thead>
                            <tr role="row">
                                <th class="sorting sorting_asc" tabindex="0"
                                    aria-controls="dataTable" rowspan="1" colspan="1"
                                    aria-sort="ascending"
                                    aria-label="순번: activate to so번rt column descending"
                                    style="width: 10%;">순번</th>
                                <th class="sorting" tabindex="0" aria-controls="dataTable"
                                    rowspan="1" colspan="1"
                                    aria-label="분류: activate to sort column ascending"
                                    style="width: 10%;">분류</th>
                                <th class="sorting" tabindex="0" aria-controls="dataTable"
                                    rowspan="1" colspan="1"
                                    aria-label="도서명: activate to sort column ascending"
                                    style="width: 15%;">도서명</th>
                                <th class="sorting" tabindex="0" aria-controls="dataTable"
                                    rowspan="1" colspan="1"
                                    aria-label="요약: activate to sort column ascending"
                                    style="width: 20%;">요약</th>
                                <th class="sorting" tabindex="0" aria-controls="dataTable"
                                    rowspan="1" colspan="1"
                                    aria-label="저자: activate to sort column ascending"
                                    style="width: 15%;">저자</th>
                                <th class="sorting" tabindex="0" aria-controls="dataTable"
                                    rowspan="1" colspan="1"
                                    aria-label="출판사: activate to sort column ascending"
                                    style="width: 15%;">출판사</th>
                                <th class="sorting" tabindex="0" aria-controls="dataTable"
                                    rowspan="1" colspan="1"
                                    aria-label="발매일: activate to sort column ascending"
                                    style="width: 15%;">발매일</th>
                            </tr>
                            </thead>
                            <tbody>
                            <!--
                                mav.addObject("data, data)
                                data: List<BookInfoVO>

                                stat.count: 1부터 시작
                                stat.index: 0부터 시작
                            -->
                            <c:forEach var="bookInfoVO" items="#{data.content}" varStatus="stat">
                                <tr class="
                                <c:if test='${stat.count%2==0}'>even</c:if>
                                <c:if test='${stat.count%2!=0}'>odd</c:if>">
                                    <td class="sorting_1">${bookInfoVO.rnum}</td>
                                    <td>${bookInfoVO.category}</td>
                                    <td><a href="/bookInfo/detailBook?bookId=${bookInfoVO.bookId}">${bookInfoVO.name}</a></td>
                                    <td>${bookInfoVO.description}</td>
                                    <td>${bookInfoVO.author}</td>
                                    <td>${bookInfoVO.publisher}</td>
                                    <td>${bookInfoVO.releaseDate}</td>
                                </tr>
                            </c:forEach>
                            <!-- total==0 이면 true -->
                            <c:if test="${data.hasNoArticles()}">
                                <tr class="odd text-center">
                                    <td colspan="7">데이터가 존재하지 않습니다.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- total>0 : true -->
                <c:if test="${data.hasArticles()}">
                    <div class="row">
                        <div class="col-sm-12 col-md-5">
                            <div class="dataTables_info" id="dataTable_info" role="status"
                                 aria-live="polite">
                                Showing ${(data.currentPage * data.size) - (data.size - 1)}
                                <c:if test="${data.total <= data.size}">to ${data.total}</c:if>
                                <c:if test="${data.total > data.size}"> to ${data.currentPage * data.size}</c:if>
                                of ${data.total} entries
                            </div>
                        </div>
                        <div class="col-sm-12 col-md-7">
                            <div class="dataTables_paginate paging_simple_numbers"
                                 id="dataTable_paginate">
                                <ul class="pagination">
                                    <li class="paginate_button page-item previous <c:if test='${data.startPage < 6}'>disabled</c:if>"
                                        id="dataTable_previous"><a href="/bookInfo/listBook?currentPage=${data.startPage - 5}&size=${data.size}&keyword=${param.keyword}"
                                                                   aria-controls="dataTable" data-dt-idx="0" tabindex="0"
                                                                   class="page-link">Previous</a></li>
                                    <c:forEach var="pNo" begin="${data.startPage}" end="${data.endPage}">
                                    <li class='paginate_button page-item <c:if test = "${param.currentPage == pNo}"> active </c:if>' >
                                            <a href="/bookInfo/listBook?currentPage=${pNo}&size=${data.size}&keyword=${param.keyword}" aria-controls="dataTable" data-dt-idx="1" tabindex="0" class="page-link">
                                                ${pNo}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    <!--부등호로 써도 된다.
                                        eq: equal           (==)
                                        ne: not equal       (!=)
                                        lt: less than       (<)
                                        gt: greater than    (>)
                                        le: less equal      (<=)
                                        ge: greater equal   (>=)
                                    -->
                                    <li class="paginate_button page-item next
                                            <c:if test='${data.endPage ge data.totalPages}'>disabled</c:if>"
                                        id="dataTable_next"><a
                                            href="/bookInfo/listBook?currentPage=${data.startPage + 5}&size=${data.size}&keyword=${param.keyword}" aria-controls="dataTable" data-dt-idx="7" tabindex="0"
                                            class="page-link">Next</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    $("#selSize").on("change", function (){
        let sVal = $(this).val();
        console.log("sVal: ", sVal);

        location.href = "/bookInfo/listBook?currentPage=1&size=" + sVal;
    })
</script>