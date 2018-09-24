<#compress >
    <#include "module/_macro.ftl">
    <@head>AppManager | App信息管理</@head>
    <div class="wrapper">
        <!-- 顶部栏模块 -->
        <#include "module/_header.ftl">
        <!-- 菜单栏模块 -->
        <#include "module/_sidebar.ftl">
        <div class="content-wrapper">
            <style type="text/css" rel="stylesheet">
                .draft, .publish, .trash {
                    list-style: none;
                    float: left;
                    margin: 0;
                    padding-bottom: 10px
                }

                #btnNewPost {
                    margin-left: 4px;
                    padding: 3px 6px;
                    position: relative;
                    top: -4px;
                    border: 1px solid #ccc;
                    border-radius: 2px;
                    background: #fff;
                    text-shadow: none;
                    font-weight: 600;
                    font-size: 12px;
                    line-height: normal;
                    color: #3c8dbc;
                    cursor: pointer;
                    transition: all .2s ease-in-out
                }

                #btnNewPost:hover {
                    background: #3c8dbc;
                    color: #fff
                }
            </style>
            <section class="content-header">
                <h1 style="display: inline-block;">APP列表</h1>
                <ol class="breadcrumb">
                    <li>
                        <a data-pjax="true" href="/admin">
                            <i class="fa fa-dashboard"></i> 首页</a>
                    </li>
                    <li><a data-pjax="true" href="#">APP列表</a></li>
                </ol>
            </section>
            <section class="content container-fluid">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="box box-primary">
                            <div class="box-body">
                                <button class="btn btn-primary btn-sm" onclick="addAppInfo()">新增</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-12">
                        <div class="box box-primary">
                            <div class="box-body table-responsive">
                                <table class="table table-bordered table-hover">
                                    <thead>
                                    <tr>
                                        <th>应用名称</th>
                                        <th>APk名称</th>
                                        <th>应用简介</th>
                                        <th>下载次数</th>
                                        <th>版本</th>
                                        <th>创建时间</th>
                                        <th>操作</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                        <#if appInfos.content?size gt 0>
                                            <#list appInfos.content as appInfo>
                                                <tr>
                                                    <td><label>${appInfo.softwareName!}</label></td>
                                                    <td>
                                                        <label>${appInfo.apkName!}</label>
                                                    </td>
                                                    <td>
                                                        <label>${appInfo.appInduction!}</label>
                                                    </td>
                                                    <td>
                                                        <label>${appInfo.downloads!}</label>
                                                    </td>
                                                    <td>
                                                        <label>${appInfo.versionId!}</label>
                                                    </td>
                                                    <td>${appInfo.creationDate?if_exists?string("yyyy-MM-dd HH:mm")}</td>
                                                    <td>
                                                        <button class="btn btn-primary btn-xs"
                                                                onclick="edit('${appInfo.id}')">编辑
                                                        </button>
                                                        <button class="btn btn-danger btn-xs"
                                                                onclick="modelShow('/admin/appInfo/delete?id=${appInfo.id}','你确定要删除？')">
                                                            删除
                                                        </button>
                                                    </td>
                                                </tr>
                                            </#list>
                                        <#else>
                                            <tr>
                                                <th colspan="6" style="text-align: center">暂无数据</th>
                                            </tr>
                                        </#if>
                                    </tbody>
                                </table>
                            </div>
                            <div class="box-footer clearfix">
                                <div class="no-margin pull-left">
                                    第${appInfos.number+1}/${appInfos.totalPages}页
                                </div>
                                <ul class="pagination no-margin pull-right">
                                    <li><a data-pjax="true"
                                           class="btn btn-sm <#if !appInfos.hasPrevious()>disabled</#if>"
                                           href="/admin/posts">首页</a></li>
                                    <li><a data-pjax="true"
                                           class="btn btn-sm <#if !appInfos.hasPrevious()>disabled</#if>"
                                           href="/admin/posts?page=${appInfos.number-1}">上一页</a></li>
                                    <li><a data-pjax="true" class="btn btn-sm <#if !appInfos.hasNext()>disabled</#if>"
                                           href="/admin/posts?page=${appInfos.number+1}">下一页</a></li>
                                    <li><a data-pjax="true" class="btn btn-sm <#if !appInfos.hasNext()>disabled</#if>"
                                           href="/admin/posts?page=${appInfos.totalPages-1}">尾页</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- 删除确认弹出层 -->
            <div class="modal fade" id="removePostModal">
                <div class="modal-dialog">
                    <div class="modal-content message_align">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">×</span></button>
                            <h4 class="modal-title">提示</h4>
                        </div>
                        <div class="modal-body">
                            <p id="message"></p>
                        </div>
                        <div class="modal-footer">
                            <input type="hidden" id="url"/>
                            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                            <a onclick="removeIt()" class="btn btn-danger" data-dismiss="modal">确定</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function modelShow(url,message) {
                $('#url').val(url);
                $('#message').html(message);
                $('#removePostModal').modal();
            }
            function removeIt(){
                var url=$.trim($("#url").val());
                window.location.href=url;
            }
            function addAppInfo() {
                layer.open({
                    type: 2,
                    title: '添加',
                    shadeClose: true,
                    shade: 0.5,
                    maxmin: true,
                    area: ['500px', '500px'],
                    content: '/admin/appInfo/toAddAppInfo',
                    scrollbar: false
                });
            }

            function edit(id) {
                layer.open({
                    type: 2,
                    title: '修改',
                    shadeClose: true,
                    shade: 0.5,
                    maxmin: true,
                    area: ['500px', '500px'],
                    content: '/admin/appInfo/toEdit?id=' + id,
                    scrollbar: false
                });
            }

        </script>
        <#include "module/_footer.ftl">
    </div>
    <@footer></@footer>
</#compress>
